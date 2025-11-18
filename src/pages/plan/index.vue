<template>
  <view class="plan-page">
    <Card>
      <view class="header">
        <text class="title">个性化学习路径</text>
        <text class="sub">基于你的学习数据与画像生成的阶段性任务</text>
      </view>
    </Card>

    <Card v-for="item in tasks" :key="item.id">
      <view class="task">
        <view class="task-left">
          <text class="task-icon">{{ item.icon }}</text>
        </view>
        <view class="task-main">
          <text class="task-title">{{ item.title }}</text>
          <text class="task-meta">学科：{{ item.subject }} · 预计：{{ item.duration }}分钟 · 难度：{{ item.level }}</text>
          <view class="task-res">
            <text v-for="r in item.resources" :key="r" class="res-tag">{{ r }}</text>
          </view>
        </view>
        <view class="task-actions">
          <Button text="开始" type="secondary" size="small" @click="startTask(item)" />
          <Button text="完成" type="primary" size="small" @click="finishTask(item)" />
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
import { useUserStore } from '@/stores/user';
import planData from '@/mock/plan.json';

const appStore = useAppStore();
const userStore = useUserStore();

const tasks = ref(planData.tasks);

const startTask = (item: any) => {
  appStore.showToast(`已开始：${item.title}`, 'none');
};

const finishTask = (item: any) => {
  userStore.addPoints(20);
  appStore.showToast('恭喜完成任务，积分+20', 'success');
  appStore.triggerEncouragement('celebration');
};
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.plan-page { min-height: 100vh; background-color: $bg-color; padding: 24rpx 32rpx; box-sizing: border-box; }
.header { display: flex; flex-direction: column; gap: 8rpx; }
.title { font-size: $font-size-lg; font-weight: bold; color: $text-primary; }
.sub { font-size: $font-size-sm; color: $text-secondary; }
.task { display: grid; grid-template-columns: auto 1fr auto; gap: 16rpx; align-items: center; }
.task-icon { font-size: 44rpx; }
.task-title { font-size: $font-size-base; font-weight: 600; color: $text-primary; }
.task-meta { display: block; font-size: $font-size-xs; color: $text-secondary; margin-top: 6rpx; }
.task-res { display: flex; gap: 8rpx; margin-top: 8rpx; }
.res-tag { padding: 6rpx 12rpx; background: $bg-color; border-radius: 16rpx; font-size: $font-size-xs; color: $text-secondary; }
.task-actions { display: flex; gap: 12rpx; }
</style>