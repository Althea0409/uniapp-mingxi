<template>
  <view class="preview-detail-page">
    <Card>
      <text class="title">{{ pv.title }}</text>
      <text class="sub">课程：{{ pv.courseName }} · 建议预习时长：{{ pv.duration }}分钟 · 发布时间：{{ pv.publishTime }}</text>
    </Card>

    <Card>
      <view class="section">
        <text class="section-title">预习内容</text>
        <view class="content-list">
          <view class="content-item" v-for="(c, i) in pv.content" :key="i">
            <text class="bullet">•</text>
            <text class="text">{{ c }}</text>
          </view>
        </view>
      </view>
    </Card>

    <Card>
      <view class="actions">
        <Button :text="pv.completed ? '已完成' : '标记完成'" :type="pv.completed ? 'secondary' : 'primary'" size="large" @click="toggleComplete" />
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

const pv = ref({
  id: 'p001',
  courseId: 'c001',
  courseName: '高等数学（上）',
  title: '第8章 课前预习任务',
  duration: 30,
  publishTime: '今天 08:00',
  content: [
    '观看视频讲解（15分钟）',
    '阅读教材 P125-P138',
    '完成思考题 3 道'
  ],
  completed: false
});

const toggleComplete = () => {
  pv.value.completed = !pv.value.completed;
  appStore.showToast(pv.value.completed ? '已标记完成' : '已取消完成', 'success');
};
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.preview-detail-page { padding: 24rpx 32rpx; }
.title { font-size: $font-size-xl; font-weight: bold; color: $text-primary; }
.sub { display: block; margin-top: 8rpx; font-size: $font-size-sm; color: $text-secondary; }
.section-title { font-size: $font-size-lg; font-weight: bold; color: $text-primary; margin-bottom: 12rpx; }
.content-list { display: flex; flex-direction: column; gap: 12rpx; }
.content-item { display: flex; gap: 12rpx; }
.bullet { font-size: 32rpx; }
.text { flex: 1; font-size: $font-size-base; color: $text-primary; line-height: 1.6; }
.actions { display: flex; justify-content: center; }
</style>

