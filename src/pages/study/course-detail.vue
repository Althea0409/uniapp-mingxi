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

      <Card>
        <view class="section">
          <text class="section-title">教学反馈</text>
          <view class="feedback-block">
            <view class="rate-row">
              <text v-for="n in 5" :key="n" :class="['star', { active: rating >= n }]" @tap="rating = n">⭐</text>
              <text class="rate-text">{{ rateText }}</text>
            </view>
            <view class="tag-list">
              <text v-for="t in tags" :key="t" :class="['tag', { selected: selectedTags.includes(t) }]"
                @tap="toggleTag(t)">{{ t }}</text>
            </view>
            <textarea class="fb-input" v-model="comment" maxlength="140" placeholder="说说课堂的亮点或建议（最多140字）" />
            <view class="fb-actions">
              <label class="checkbox-label" @tap="anonymous = !anonymous">
                <text class="checkbox">{{ anonymous ? '☑' : '☐' }}</text>
                <text class="option-text">匿名提交</text>
              </label>
              <Button :text="submitting ? '提交中' : '提交反馈'" :type="submitting ? 'secondary' : 'primary'" size="small"
                :disabled="submitting" @click="submitFeedback" />
            </view>
            <text v-if="leftChars <= 20" class="char-tip">还可输入 {{ leftChars }} 字</text>
          </view>
        </view>
      </Card>
    </view>
  </view>

</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import { onLoad } from '@dcloudio/uni-app';
import Card from '@/components/common/Card.vue';
import Button from '@/components/common/Button.vue';
import Loading from '@/components/common/Loading.vue';
import coursesJson from '@/mock/courses.json';
import { useAppStore } from '@/stores/app';
import portraitData from '@/mock/portrait.json';
import { storage, StorageKeys } from '@/utils/storage';
import { useUserStore } from '@/stores/user';

const appStore = useAppStore();
const userStore = useUserStore();

function detectSubject(name: string): string {
  if (!name) return '综合';
  if (name.includes('语文')) return '语文';
  if (name.includes('数学')) return '数学';
  if (name.includes('英语')) return '英语';
  if (name.includes('科学')) return '科学';
  if (name.includes('社政') || name.includes('历史与社会')) return '社政';
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
    case '社政':
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

const rating = ref(0);
const tags = ['讲解清晰', '互动性强', '节奏适中', '作业有帮助', '答疑及时', '课堂有趣'];
const selectedTags = ref<string[]>([]);
const anonymous = ref(false);
const comment = ref('');
const submitting = ref(false);
const leftChars = computed(() => Math.max(0, 140 - (comment.value?.length || 0)));
const rateText = computed(() => ({ 0: '请为本次教学打分', 1: '需要改进', 2: '一般', 3: '良好', 4: '很棒', 5: '非常棒' } as any)[rating.value]);

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
    const lows = [...(pd.classicKnowledge || []), ...(pd.modernKnowledge || [])]
      .filter((x: any) => typeof x.value === 'number' && x.value <= 75)
      .slice(0, 2);
    const resList = (pd.resources || []).slice(0, 3);
    resources.value = resList.map((r: any) => ({
      id: r.id,
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
  const id = encodeURIComponent(`${course.value.id}-${r.id}`);
  appStore.navigateTo(`/pages/discover/resource-detail?id=${id}`);
};

const toggleTag = (t: string) => {
  const i = selectedTags.value.indexOf(t);
  if (i >= 0) selectedTags.value.splice(i, 1);
  else selectedTags.value.push(t);
};

const submitFeedback = async () => {
  if (!rating.value) { appStore.showToast('请先选择评分', 'none'); return; }
  submitting.value = true;
  try {
    const item = {
      courseId: course.value.id,
      courseName: course.value.name,
      teacher: course.value.teacher,
      rating: rating.value,
      tags: [...selectedTags.value],
      comment: comment.value?.trim() || '',
      anonymous: anonymous.value,
      at: Date.now(),
    };
    const list = (storage.get(StorageKeys.TEACHING_FEEDBACK) as any) || [];
    list.push(item);
    storage.set(StorageKeys.TEACHING_FEEDBACK, list);
    const logs = (storage.get(StorageKeys.GROWTH_LOG) as any) || [];
    logs.push({ type: 'feedback', courseId: item.courseId, courseName: item.courseName, rating: item.rating, at: item.at });
    storage.set(StorageKeys.GROWTH_LOG, logs);
    userStore.addPoints(5);
    appStore.showToast('已提交反馈，积分+5', 'success');
    rating.value = 0; selectedTags.value = []; comment.value = ''; anonymous.value = false;
  } catch (e) {
    appStore.showToast('提交失败，请稍后再试', 'error');
  } finally {
    submitting.value = false;
  }
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

.meta {
  display: flex;
  gap: 24rpx;
  margin-bottom: 16rpx;
}

.meta-item {
  font-size: $font-size-sm;
  color: $text-secondary;
}

.actions {
  margin-top: 8rpx;
}

.section {
  padding: 8rpx;
}

.section-title {
  font-size: $font-size-lg;
  font-weight: bold;
  color: $text-primary;
  margin-bottom: 16rpx;
}

.resource-list {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}

.resource-item {
  display: flex;
  align-items: center;
  gap: 16rpx;
}

.resource-icon {
  font-size: 40rpx;
}

.resource-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4rpx;
}

.resource-title {
  font-size: $font-size-base;
  color: $text-primary;
}

.resource-desc {
  font-size: $font-size-sm;
  color: $text-secondary;
}

.schedule-list {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}

.schedule-item {
  display: flex;
  gap: 16rpx;
}

.time {
  width: 280rpx;
  font-size: $font-size-sm;
  color: $text-secondary;
}

.schedule-content {
  flex: 1;
}

.sch-title {
  display: block;
  font-size: $font-size-base;
  color: $text-primary;
  font-weight: 500;
}

.sch-sub {
  display: block;
  font-size: $font-size-sm;
  color: $text-secondary;
}

.feedback-block {
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}

.rate-row {
  display: flex;
  align-items: center;
  gap: 8rpx;
}

.star {
  font-size: 40rpx;
  opacity: 0.3;
}

.star.active {
  opacity: 1;
}

.rate-text {
  font-size: $font-size-sm;
  color: $text-secondary;
  margin-left: 8rpx;
}

.tag-list {
  display: flex;
  flex-wrap: wrap;
  gap: 8rpx;
}

.tag {
  padding: 6rpx 14rpx;
  border-radius: 24rpx;
  background: $bg-color;
  font-size: $font-size-xs;
  color: $text-secondary;
}

.tag.selected {
  background: rgba(43, 70, 254, 0.1);
  color: $primary-color;
  font-weight: bold;
}

.fb-input {
  width: 100%;
  min-height: 120rpx;
  background: $bg-color;
  border-radius: $border-radius;
  padding: 12rpx;
  font-size: $font-size-base;
  color: $text-primary;
}

.fb-actions {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.checkbox-label {
  display: flex;
  align-items: center;
  gap: 8rpx;
}

.checkbox {
  font-size: $font-size-base;
}

.option-text {
  font-size: $font-size-sm;
  color: $text-secondary;
}

.char-tip {
  font-size: $font-size-xs;
  color: $accent-color;
  text-align: right;
}
</style>
