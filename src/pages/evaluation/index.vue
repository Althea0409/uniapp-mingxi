<template>
  <view class="evaluation-page">
    <scroll-view scroll-y class="content">
      <Card>
        <view class="period-tabs">
          <view v-for="p in periods" :key="p" :class="['period', { active: p === period }]" @tap="period = p">{{ p }}</view>
        </view>
      </Card>

      <Card>
        <view class="overview">
          <view class="radar-placeholder">
            <text class="radar-text">雷达图占位</text>
          </view>
          <view class="labels">
            <text>知识掌握</text>
            <text>作业质量</text>
            <text>学习态度</text>
            <text>课堂参与</text>
            <text>自主学习</text>
          </view>
          <text class="score">综合得分：85/100 · 超越 78%</text>
        </view>
      </Card>

      <Card>
        <view class="metric">
          <text class="metric-title">📚 知识掌握度</text>
          <view class="metric-bar"><view class="fill" style="width: 88%"></view></view>
          <text class="metric-sub">高数(92%) 英语(85%) 物理(87%)</text>
        </view>
      </Card>

      <Card>
        <view class="metric">
          <text class="metric-title">✅ 作业完成质量</text>
          <view class="metric-bar"><view class="fill" style="width: 90%"></view></view>
          <text class="metric-sub">按时率(95%) 正确率(88%) · 建议：加强计算题练习</text>
        </view>
      </Card>

      <Card>
        <view class="metric">
          <text class="metric-title">💬 课堂参与度</text>
          <view class="metric-bar"><view class="fill" style="width: 75%"></view></view>
          <text class="metric-sub">讨论次数(8) 提问次数(3) · 建议：多参与课堂讨论</text>
        </view>
      </Card>

      <Card>
        <view class="metric">
          <text class="metric-title">⏰ 学习时长统计</text>
          <view class="metric-bar"><view class="fill" style="width: 62%"></view></view>
          <text class="metric-sub">本周总计：12.5小时 · 日均：2.5小时</text>
        </view>
      </Card>

      <Card>
        <view class="ai-section">
          <text class="ai-title">🤖 AI学习分析</text>
          <text class="ai-text">• 你在数学学科表现优异，保持！\n• 英语学习时长略少，建议增加...\n• 课堂参与度有提升空间，可以...</text>
          <Button text="生成学习计划建议" type="primary" size="large" @click="genPlan" />
        </view>
      </Card>
    </scroll-view>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import Card from '@/components/common/Card.vue';
import Button from '@/components/common/Button.vue';
import { useAppStore } from '@/stores/app';

const appStore = useAppStore();
const periods = ['本周', '本月', '本学期'];
const period = ref('本周');

const genPlan = () => {
  appStore.showToast('生成学习计划功能开发中', 'none');
};
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.content { padding: 24rpx 32rpx 24rpx 32rpx; box-sizing: border-box; width: 100%; }

.period-tabs { display: flex; gap: 16rpx; }
.period { padding: 8rpx 16rpx; background: $bg-color; border-radius: 24rpx; font-size: $font-size-sm; color: $text-secondary; }
.period.active { background: $card-bg; color: $primary-color; font-weight: bold; box-shadow: 0 4rpx 12rpx rgba(0,0,0,0.05); }

.overview { display: flex; flex-direction: column; gap: 12rpx; align-items: center; }
.radar-placeholder { width: 240rpx; height: 240rpx; border-radius: 120rpx; background: radial-gradient(#f0f0f0, #e5e5e5); display: flex; align-items: center; justify-content: center; }
.radar-text { color: $text-placeholder; }
.labels { display: grid; grid-template-columns: repeat(3, auto); gap: 8rpx 16rpx; color: $text-secondary; font-size: $font-size-xs; }
.score { margin-top: 8rpx; font-size: $font-size-sm; color: $text-primary; }

.metric { display: flex; flex-direction: column; gap: 8rpx; }
.metric-title { font-size: $font-size-base; color: $text-primary; font-weight: 600; }
.metric-bar { height: 12rpx; background: $divider-color; border-radius: 6rpx; overflow: hidden; }
.fill { height: 100%; background: $gradient-primary; }
.metric-sub { font-size: $font-size-xs; color: $text-secondary; }

.ai-section { display: flex; flex-direction: column; gap: 12rpx; }
.ai-title { font-size: $font-size-lg; font-weight: bold; color: $text-primary; }
.ai-text { white-space: pre-line; font-size: $font-size-sm; color: $text-secondary; line-height: 1.6; }
</style>

