<template>
  <view class="growth-page">
    <Card>
      <text class="title">成长档案</text>
      <text class="sub">记录你的任务完成、积分变化与激励时刻</text>
      <view class="summary">
        <view class="sum-item">
          <text class="sum-value">{{ taskCount }}</text>
          <text class="sum-label">完成任务</text>
        </view>
        <view class="sum-item">
          <text class="sum-value">{{ totalMinutes }}</text>
          <text class="sum-label">学习分钟</text>
        </view>
        <view class="sum-item">
          <text class="sum-value">{{ pointsDelta }}</text>
          <text class="sum-label">积分变更</text>
        </view>
        <view class="sum-item">
          <text class="sum-value">{{ encourageCount }}</text>
          <text class="sum-label">激励触发</text>
        </view>
      </view>
      <view class="filter-tabs">
        <view :class="['tab', {active: current==='all'}]" @tap="current='all'">全部</view>
        <view :class="['tab', {active: current==='task'}]" @tap="current='task'">任务</view>
        <view :class="['tab', {active: current==='points'}]" @tap="current='points'">积分</view>
        <view :class="['tab', {active: current==='encourage'}]" @tap="current='encourage'">激励</view>
      </view>
    </Card>

    <scroll-view scroll-y class="content">
      <Card v-for="(item, i) in filtered" :key="i">
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
import { ref, computed } from 'vue';
import Card from '@/components/common/Card.vue';
import { storage, StorageKeys } from '@/utils/storage';

const raw = (storage.get(StorageKeys.GROWTH_LOG) as any) || [];
const logs = ref<any[]>([...raw].reverse());
const current = ref<'all'|'task'|'points'|'encourage'>('all');
const filtered = computed(()=> current.value==='all'? logs.value : logs.value.filter(x=>x.type===current.value));

const format = (ts: number) => {
  const d = new Date(ts);
  const pad = (n:number)=> (n<10?('0'+n):''+n);
  return `${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}`;
};
const typeText = (t: string) => ({ fatigue: '疲劳提醒', encourage: '鼓励提醒', celebration: '庆祝提醒', daily: '晚安提醒' } as any)[t] || t;
const taskCount = computed(()=> logs.value.filter(x=>x.type==='task').length);
const totalMinutes = computed(()=> logs.value.filter(x=>x.type==='task').reduce((s,x)=> s + (x.duration||0), 0));
const pointsDelta = computed(()=> logs.value.filter(x=>x.type==='points').reduce((s,x)=> s + (x.delta||0), 0));
const encourageCount = computed(()=> logs.value.filter(x=>x.type==='encourage').length);

</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.growth-page { min-height: 100vh; background-color: $bg-color; padding: 24rpx 32rpx; box-sizing: border-box; }
.title { font-size: $font-size-lg; font-weight: bold; color: $text-primary; }
.sub { display:block; margin-top:8rpx; font-size:$font-size-sm; color:$text-secondary; }
.content { padding-top: 8rpx; }
.summary { display: grid; grid-template-columns: repeat(4,1fr); gap: 16rpx; margin-top: 12rpx; }
.sum-item { background: $bg-color; border-radius: $border-radius; padding: 16rpx; text-align: center; }
.sum-value { font-size: $font-size-lg; font-weight: bold; color: $text-primary; }
.sum-label { font-size: $font-size-xs; color: $text-secondary; }
.filter-tabs { display: flex; gap: 12rpx; margin-top: 12rpx; }
.filter-tabs .tab { padding: 8rpx 16rpx; background: $bg-color; border-radius: 24rpx; font-size: $font-size-xs; color: $text-secondary; }
.filter-tabs .tab.active { background: rgba(43,70,254,0.1); color: $primary-color; font-weight: bold; }
.log-item { display:flex; flex-direction:column; gap:6rpx; }
.log-title { font-size:$font-size-base; color:$text-primary; font-weight:600; }
.log-meta { font-size:$font-size-xs; color:$text-secondary; }
.log-reason { font-size:$font-size-xs; color:$primary-color; }
</style>