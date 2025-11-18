<template>
  <view class="growth-page">
    <Card>
      <text class="title">成长档案</text>
      <text class="sub">记录你的任务完成、积分变化与激励时刻</text>
    </Card>

    <scroll-view scroll-y class="content">
      <Card v-for="(item, i) in logs" :key="i">
        <view class="log-item" v-if="item.type==='task'">
          <text class="log-title">完成任务：{{ item.title }}</text>
          <text class="log-meta">学科：{{ item.subject }} · 时长：{{ item.duration }}分钟 · 时间：{{ format(item.finishedAt) }}</text>
          <text v-if="item.reason" class="log-reason">推荐原因：{{ item.reason }}</text>
        </view>
        <view class="log-item" v-else-if="item.type==='points'">
          <text class="log-title">积分变更：+{{ item.delta }}</text>
          <text class="log-meta">时间：{{ format(item.at) }}</text>
        </view>
        <view class="log-item" v-else-if="item.type==='encourage'">
          <text class="log-title">激励触发：{{ typeText(item.encourageType) }}</text>
          <text class="log-meta">时间：{{ format(item.at) }}</text>
          <text class="log-reason">文案：{{ item.text }}</text>
        </view>
      </Card>
    </scroll-view>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import Card from '@/components/common/Card.vue';
import { storage, StorageKeys } from '@/utils/storage';

const raw = (storage.get(StorageKeys.GROWTH_LOG) as any) || [];
const logs = ref(raw);

const format = (ts: number) => {
  const d = new Date(ts);
  const pad = (n:number)=> (n<10?('0'+n):''+n);
  return `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}`;
};
const typeText = (t: string) => ({ fatigue: '疲劳提醒', encourage: '鼓励提醒', celebration: '庆祝提醒', daily: '晚安提醒' } as any)[t] || t;
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.growth-page { min-height: 100vh; background-color: $bg-color; padding: 24rpx 32rpx; box-sizing: border-box; }
.title { font-size: $font-size-lg; font-weight: bold; color: $text-primary; }
.sub { display:block; margin-top:8rpx; font-size:$font-size-sm; color:$text-secondary; }
.content { padding-top: 8rpx; }
.log-item { display:flex; flex-direction:column; gap:6rpx; }
.log-title { font-size:$font-size-base; color:$text-primary; font-weight:600; }
.log-meta { font-size:$font-size-xs; color:$text-secondary; }
.log-reason { font-size:$font-size-xs; color:$primary-color; }
</style>