<template>
  <view class="course-detail-page">
    <Loading v-if="loading" text="正在加载课程..." />
    <view v-else>
      <Card>
        <view class="cover">
          <image class="cover-img" :src="cover" mode="aspectFill" />
          <view class="status-tag">{{ course.tag }}</view>
        </view>
        <view class="info">
          <text class="title">{{ course.name }}</text>
          <text class="sub">{{ course.teacher }} · {{ course.department }}</text>
          <view class="progress-row">
            <view class="progress-bar">
              <view class="progress-fill" :style="{ width: course.progress + '%' }"></view>
            </view>
            <text class="progress-text">{{ course.progress }}%</text>
          </view>
          <view class="meta">
            <text class="meta-item">📖 {{ course.chapter }}</text>
            <text class="meta-item">⏰ {{ course.nextClass }}</text>
          </view>
          <view class="actions">
            <Button text="继续学习" type="primary" size="large" @click="continueStudy" />
          </view>
        </view>
      </Card>

      <Card>
        <view class="section">
          <text class="section-title">课程资源</text>
          <view class="resource-list">
            <view class="resource-item" v-for="(r, i) in resources" :key="i">
              <text class="resource-icon">{{ r.icon }}</text>
              <view class="resource-content">
                <text class="resource-title">{{ r.title }}</text>
                <text class="resource-desc">{{ r.desc }}</text>
              </view>
              <Button text="查看" type="secondary" size="small" @click="viewResource(r)" />
            </view>
          </view>
        </view>
      </Card>

      <Card>
        <view class="section">
          <text class="section-title">近期课程安排</text>
          <view class="schedule-list">
            <view class="schedule-item" v-for="(s, i) in schedule" :key="i">
              <text class="time">{{ s.time }}</text>
              <view class="schedule-content">
                <text class="sch-title">{{ s.title }}</text>
                <text class="sch-sub">{{ s.location }} · {{ s.teacher }}</text>
              </view>
            </view>
          </view>
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
import coursesJson from '@/mock/courses.json';
import { useAppStore } from '@/stores/app';
import portraitData from '@/mock/portrait.json';

const appStore = useAppStore();

function detectSubject(name: string): string {
  if (!name) return '综合';
  if (name.includes('语文')) return '语文';
  if (name.includes('数学')) return '数学';
  if (name.includes('英语')) return '英语';
  if (name.includes('科学')) return '科学';
  if (name.includes('历史与社会')) return '历史与社会';
  return '综合';
}

function getCoverBySubject(subject: string): string {
  switch (subject) {
    case '语文':
      return '/static/course/chinese.svg';
    case '数学':
      return '/static/course/math.svg';
    case '英语':
      return '/static/course/english.svg';
    case '科学':
      return '/static/course/science.svg';
    case '历史与社会':
      return '/static/course/history.svg';
    default:
      return '/static/logo.png';
  }
}

const loading = ref(true);
const cover = ref('/static/logo.png');
const course = ref<any>({
  id: '',
  name: '',
  teacher: '',
  department: '',
  progress: 0,
  chapter: '',
  nextClass: '',
  tag: '进行中'
});

const resources = ref<any[]>([]);

const schedule = ref([
  { time: '周二 10:00 - 11:40', title: '课堂学习', location: '教学楼A-201', teacher: '' },
  { time: '周四 14:00 - 15:40', title: '复习巩固', location: '教学楼A-201', teacher: '' },
]);

function loadCourse(id: string) {
  loading.value = true;
  const list = (coursesJson as any).courses || [];
  const c = list.find((x: any) => x.id === id);
  if (!c) {
    loading.value = false;
    appStore.showToast('课程不存在', 'none');
    return;
  }
  const subject = detectSubject(c.name);
  cover.value = getCoverBySubject(subject);
  course.value = {
    id: c.id,
    name: c.name,
    teacher: c.teacher,
    department: c.department,
    progress: c.progress || 0,
    chapter: c.chapter || '',
    nextClass: c.nextClass || '',
    tag: c.status === 'completed' ? '已完成' : '进行中'
  };
  const pd: any = (portraitData as any)[subject];
  if (pd) {
    const lows = [...(pd.classicKnowledge||[]), ...(pd.modernKnowledge||[])]
      .filter((x: any) => typeof x.value === 'number' && x.value <= 75)
      .slice(0, 2);
    const resList = (pd.resources||[]).slice(0, 3);
    resources.value = resList.map((r: any) => ({
      icon: r.icon || '📚',
      title: r.title,
      desc: r.desc || '',
      match: r.match || 85,
      reason: lows[0] ? `针对“${lows[0].name}”巩固（掌握度${lows[0].value}%）` : '结合课程进度推荐',
    }));
  } else {
    resources.value = [
      { icon: '🎬', title: '课堂视频', desc: '核心知识讲解' },
      { icon: '📚', title: '配套练习', desc: '精选习题与解析' },
      { icon: '📄', title: '课件与笔记', desc: '资料打包下载' },
    ];
  }
  schedule.value = [
    { time: '周二 10:00 - 11:40', title: course.value.chapter || '课堂学习', location: '教学楼A-201', teacher: course.value.teacher },
    { time: '周四 14:00 - 15:40', title: '复习巩固', location: '教学楼A-201', teacher: course.value.teacher },
  ];
  loading.value = false;
}

onLoad((options: any) => {
  const id = options?.id || '';
  loadCourse(id);
});

const continueStudy = () => {
  appStore.showToast('继续学习功能开发中', 'none');
};

const viewResource = (r: any) => {
  const id = encodeURIComponent(`${course.value.id}-${r.title}`);
  appStore.navigateTo(`/pages/discover/resource-detail?id=${id}`);
};
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.course-detail-page {
  padding: 24rpx 32rpx;
}

.cover {
  height: 220rpx;
  background-color: $divider-color;
  border-radius: $border-radius;
  position: relative;
}

.cover-img {
  width: 100%;
  height: 100%;
  border-radius: $border-radius;
}

.status-tag {
  position: absolute;
  top: 16rpx;
  right: 16rpx;
  padding: 8rpx 16rpx;
  background: rgba(43, 70, 254, 0.9);
  border-radius: 24rpx;
  color: $text-white;
  font-size: $font-size-xs;
  font-weight: bold;
}

.info {
  padding: 24rpx;
}

.title {
  display: block;
  font-size: $font-size-xl;
  font-weight: bold;
  color: $text-primary;
}

.sub {
  display: block;
  margin-top: 8rpx;
  font-size: $font-size-sm;
  color: $text-secondary;
}

.progress-row {
  display: flex;
  align-items: center;
  gap: 16rpx;
  margin: 16rpx 0;
}

.progress-bar {
  flex: 1;
  height: 12rpx;
  background-color: $divider-color;
  border-radius: 6rpx;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  background: $gradient-primary;
}

.progress-text {
  font-size: $font-size-xs;
  color: $primary-color;
  font-weight: bold;
}

.meta { display: flex; gap: 24rpx; margin-bottom: 16rpx; }
.meta-item { font-size: $font-size-sm; color: $text-secondary; }

.actions { margin-top: 8rpx; }

.section { padding: 8rpx; }
.section-title { font-size: $font-size-lg; font-weight: bold; color: $text-primary; margin-bottom: 16rpx; }

.resource-list { display: flex; flex-direction: column; gap: 16rpx; }
.resource-item { display: flex; align-items: center; gap: 16rpx; }
.resource-icon { font-size: 40rpx; }
.resource-content { flex: 1; display: flex; flex-direction: column; gap: 4rpx; }
.resource-title { font-size: $font-size-base; color: $text-primary; }
.resource-desc { font-size: $font-size-sm; color: $text-secondary; }

.schedule-list { display: flex; flex-direction: column; gap: 16rpx; }
.schedule-item { display: flex; gap: 16rpx; }
.time { width: 280rpx; font-size: $font-size-sm; color: $text-secondary; }
.schedule-content { flex: 1; }
.sch-title { display: block; font-size: $font-size-base; color: $text-primary; font-weight: 500; }
.sch-sub { display: block; font-size: $font-size-sm; color: $text-secondary; }
</style>

