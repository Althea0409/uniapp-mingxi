<template>
  <view class="course-detail-page">
    <Card>
      <view class="cover">
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
  
</template>

<script setup lang="ts">
import { ref } from 'vue';
import Card from '@/components/common/Card.vue';
import Button from '@/components/common/Button.vue';
import { useAppStore } from '@/stores/app';

const appStore = useAppStore();

const course = ref({
  name: '高等数学（上）',
  teacher: '张教授',
  department: '数学学院',
  progress: 78,
  chapter: '第8章',
  nextClass: '本周3节课',
  tag: '进行中'
});

const resources = ref([
  { icon: '🎬', title: '函数与极限精讲视频', desc: '时长 18 分钟' },
  { icon: '📚', title: '极限运算练习题', desc: '10 题 · 含解析' },
  { icon: '📄', title: '课堂PPT与笔记', desc: '第8章资料包' },
]);

const schedule = ref([
  { time: '周二 10:00 - 11:40', title: '第8章：函数极限', location: '教学楼A-201', teacher: '张教授' },
  { time: '周四 14:00 - 15:40', title: '第8章：连续性', location: '教学楼A-201', teacher: '张教授' },
]);

const continueStudy = () => {
  appStore.showToast('继续学习功能开发中', 'none');
};

const viewResource = (r: any) => {
  appStore.showToast(`查看资源：${r.title}`, 'none');
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

