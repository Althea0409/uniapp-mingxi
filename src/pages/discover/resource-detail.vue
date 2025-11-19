<template>
  <view class="resource-detail-page">
    <Loading v-if="loading" text="正在加载资源..." />
    <view v-else>
      <Card>
        <view class="header">
          <image class="cover" :src="res.cover" mode="aspectFill" />
          <view class="meta">
            <text class="title">{{ res.title }}</text>
            <view class="tags">
              <view :class="['type', res.type]">{{ res.typeName }}</view>
              <text class="match">匹配度 {{ res.matchRate }}%</text>
            </view>
            <text class="reason" v-if="res.reason">推荐理由：{{ res.reason }}</text>
          </view>
        </view>
      </Card>

      <Card>
        <view class="section">
          <text class="section-title">资源简介</text>
          <text class="desc">{{ res.description }}</text>
          <view class="info-row">
            <text v-if="res.time" class="info">学习时长：{{ res.time }}</text>
            <text v-if="res.rating" class="info">评分：{{ res.rating }}</text>
          </view>
        </view>
      </Card>

      <Card>
        <view class="section">
          <text class="section-title">学习建议</text>
          <view class="tips">
            <text>1）先浏览目录，明确目标与输出</text>
            <text>2）做简短摘记与要点卡片</text>
            <text>3）完成后进行3分钟总结与自测</text>
          </view>
        </view>
      </Card>

      <Card>
        <view class="actions">
          <Button text="开始学习" type="primary" size="large" @click="start" />
        </view>
      </Card>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { onLoad } from '@dcloudio/uni-app';
import Card from '@/components/common/Card.vue';
import Button from '@/components/common/Button.vue';
import Loading from '@/components/common/Loading.vue';
import { useAppStore } from '@/stores/app';
import { useCourseStore } from '@/stores/course';
import achievementsJson from '@/mock/achievements.json';
import portraitData from '@/mock/portrait.json';

const appStore = useAppStore();
const courseStore = useCourseStore();

const loading = ref(true);
const res = ref<any>({});

function mapTypeName(t: string): { type: string; typeName: string } {
  if (t === 'video' || t === '视频') return { type: 'video', typeName: '视频' };
  if (t === 'audio' || t === '音频') return { type: 'audio', typeName: '音频' };
  if (t === 'exercise' || t === '练习') return { type: 'exercise', typeName: '练习' };
  return { type: 'document', typeName: '文档' };
}

function getSubjectCover(subject: string): string {
  switch (subject) {
    case '语文': return '/static/resource/subject-chinese.svg';
    case '数学': return '/static/resource/subject-math.svg';
    case '英语': return '/static/resource/subject-english.svg';
    case '科学': return '/static/resource/subject-science.svg';
    case '历史与社会': return '/static/resource/subject-history.svg';
    default: return '/static/resource/doc.svg';
  }
}

function detectSubject(name: string): string {
  if (!name) return '综合';
  if (name.includes('语文')) return '语文';
  if (name.includes('数学')) return '数学';
  if (name.includes('英语')) return '英语';
  if (name.includes('科学')) return '科学';
  if (name.includes('历史')) return '历史与社会';
  return '综合';
}

function genAllResources() {
  const base = (achievementsJson as any).resources || [];
  const ongoing = courseStore.ongoingCourses || [];
  const wrong = (appStore as any).consecutiveWrong || 0;
  const pooled: any[] = [];

  for (const c of ongoing) {
    const subject = detectSubject(c.name);
    const pd: any = (portraitData as any)[subject];
    if (!pd) continue;
    const lows = [...(pd.classicKnowledge||[]), ...(pd.modernKnowledge||[])]
      .filter((x: any) => typeof x.value === 'number' && x.value <= 75)
      .slice(0, 2);
    const resList = (pd.resources||[]).slice(0, 3);
    for (const r of resList) {
      const { type, typeName } = mapTypeName(r.type);
      let match = (r.match || r.matchRate || 80);
      if (c.progress >= 60 && lows.length > 0) match = Math.min(98, match + 8);
      if (c.progress < 40) match = Math.max(60, match - 6);
      if (wrong >= 3) match = Math.min(99, match + 5);
      const reasonParts = [] as string[];
      if (lows[0]) reasonParts.push(`“${lows[0].name}”掌握度${lows[0].value}%偏弱`);
      if (c.progress) reasonParts.push(`当前课程进度${c.progress}%`);
      if (wrong >= 3) reasonParts.push('近期错题较多，建议巩固');
      pooled.push({
        id: `${c.id}-${r.id}`,
        cover: getSubjectCover(subject),
        title: r.title,
        description: r.desc || r.description || '',
        type,
        typeName,
        subject,
        time: r.duration ? `${r.duration}分钟` : '推荐',
        matchRate: match,
        rating: r.rating || undefined,
        reason: reasonParts.join('；')
      });
    }
  }

  for (const r of base) {
    const { type, typeName } = mapTypeName(r.type);
    const subject = detectSubject(r.title || r.description || '');
    const cover = (r.cover && r.cover !== '/static/logo.png') ? r.cover : getSubjectCover(subject);
    pooled.push({
      id: r.id,
      cover,
      title: r.title,
      description: r.description,
      type,
      typeName,
      subject,
      time: r.duration ? `${r.duration}分钟` : '推荐',
      matchRate: r.matchRate || 85,
      rating: r.rating || undefined,
      reason: r.reason || '结合学习画像为你推荐'
    });
  }

  const subjectKeys = Object.keys(portraitData || {});
  for (const key of subjectKeys) {
    const pd: any = (portraitData as any)[key];
    const lows = [...(pd.classicKnowledge||[]), ...(pd.modernKnowledge||[])]
      .filter((x: any) => typeof x.value === 'number' && x.value <= 75)
      .slice(0, 2);
    const resList = (pd.resources||[]).slice(0, 3);
    for (const r of resList) {
      const { type, typeName } = mapTypeName(r.type);
      const baseMatch = (pd.knowledge?.overall || pd.skills?.mastery || 75);
      const match = Math.min(99, Math.max(60, baseMatch + (lows.length>0 ? 8 : 0)));
      pooled.push({
        id: `pf-${key}-${r.id}`,
        cover: getSubjectCover(key),
        title: r.title,
        description: r.desc || r.description || '',
        type,
        typeName,
        subject: key,
        time: r.duration ? `${r.duration}分钟` : '推荐',
        matchRate: match,
        rating: r.rating || undefined,
        reason: lows[0] ? `“${lows[0].name}”掌握度${lows[0].value}%偏弱` : `画像整体掌握度${baseMatch}%`
      });
    }
  }

  return pooled;
}

function loadResource(id: string) {
  loading.value = true;
  const list = genAllResources();
  const item = list.find((x) => x.id === id);
  if (!item) {
    loading.value = false;
    appStore.showToast('资源不存在', 'none');
    return;
  }
  res.value = item;
  loading.value = false;
}

onLoad((options: any) => {
  const id = decodeURIComponent(options?.id || '');
  loadResource(id);
});

const start = () => {
  appStore.recordStudySession(20);
  appStore.logTask(res.value.title, res.value.subject || '综合', 20, res.value.reason || '资源学习');
  appStore.showToast('已开始学习该资源', 'success');
};
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.resource-detail-page { padding: 24rpx 32rpx; }

.header { display: flex; gap: 24rpx; }
.cover { width: 200rpx; height: 140rpx; border-radius: $border-radius; background-color: $divider-color; }
.meta { flex: 1; display: flex; flex-direction: column; gap: 8rpx; }
.title { font-size: $font-size-lg; font-weight: bold; color: $text-primary; }
.tags { display: flex; align-items: center; gap: 16rpx; }
.type { padding: 6rpx 16rpx; border-radius: 24rpx; font-size: $font-size-xs; font-weight: bold; }
.type.video { background-color: rgba(123, 97, 255, 0.1); color: $secondary-color; }
.type.document { background-color: rgba(43, 70, 254, 0.1); color: $primary-color; }
.type.audio { background-color: rgba(255, 184, 77, 0.1); color: $accent-color; }
.type.exercise { background-color: rgba(24, 144, 255, 0.1); color: $info-color; }
.match { font-size: $font-size-xs; color: $text-placeholder; }
.reason { font-size: $font-size-sm; color: $primary-color; }

.section-title { font-size: $font-size-lg; font-weight: bold; color: $text-primary; margin-bottom: 12rpx; }
.desc { font-size: $font-size-base; color: $text-secondary; line-height: 1.6; }
.info-row { margin-top: 12rpx; display: flex; gap: 24rpx; }
.info { font-size: $font-size-sm; color: $text-secondary; }

.tips { display: flex; flex-direction: column; gap: 8rpx; font-size: $font-size-sm; color: $text-secondary; }

.actions { display: flex; justify-content: center; }
</style>