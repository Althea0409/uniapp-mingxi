<template>
  <view class="schedule-page">
    <view class="week-selector">
      <text class="arrow" @tap="prevWeek">‹</text>
      <text class="week-text">第{{ week }}周 (11/17-11/23)</text>
      <text class="arrow" @tap="nextWeek">›</text>
    </view>

    <scroll-view class="day-tabs" scroll-x>
      <view v-for="d in days" :key="d.date" :class="['day-item', { current: d.isToday }]">
        <text class="day-week">{{ d.week }}</text>
        <text class="day-date">{{ d.date }}</text>
      </view>
    </scroll-view>

    <view class="timeline">
      <view class="time-item" v-for="(item, i) in schedule" :key="i">
        <text class="time">{{ item.startTime }}</text>
        <view class="card">
          <text class="c-title">{{ item.courseName }}</text>
          <text class="c-sub">📍 {{ item.location }} · 👨‍🏫 {{ item.teacher }}</text>
        </view>
      </view>
      <view class="time-item">
        <text class="time">16:00</text>
        <view class="suggest">
          <text class="s-title">空闲时间</text>
          <text class="s-sub">💡 建议：完成课前预习任务</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue';

const week = ref(10);
const days = ref([
  { week: '周一', date: '17', isToday: false },
  { week: '周二', date: '18', isToday: true },
  { week: '周三', date: '19', isToday: false },
  { week: '周四', date: '20', isToday: false },
  { week: '周五', date: '21', isToday: false },
  { week: '周六', date: '22', isToday: false },
  { week: '周日', date: '23', isToday: false },
]);

const schedule = ref([
  { startTime: '08:00', courseName: '高等数学', location: '教学楼A-201', teacher: '张教授' },
  { startTime: '10:00', courseName: '大学英语', location: '外语楼B-305', teacher: 'Lisa老师' },
  { startTime: '14:00', courseName: '计算机程序设计', location: '实验楼C-102', teacher: '王老师' },
]);

const prevWeek = () => { if (week.value > 1) week.value--; };
const nextWeek = () => { week.value++; };
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.schedule-page { padding: 24rpx 32rpx; }

.week-selector { display: flex; align-items: center; justify-content: center; gap: 24rpx; margin-bottom: 16rpx; }
.arrow { font-size: 40rpx; cursor: pointer; }
.week-text { font-size: $font-size-base; color: $text-primary; }

.day-tabs { display: flex; gap: 16rpx; padding: 8rpx 0 16rpx; }
.day-item { width: 96rpx; height: 88rpx; background: $bg-color; border-radius: $border-radius; display: flex; flex-direction: column; align-items: center; justify-content: center; }
.day-item.current { background: $card-bg; box-shadow: 0 4rpx 12rpx rgba(0,0,0,0.05); }
.day-week { font-size: $font-size-xs; color: $text-secondary; }
.day-date { font-size: $font-size-base; color: $text-primary; font-weight: bold; }

.timeline { display: flex; flex-direction: column; gap: 24rpx; }
.time-item { display: flex; gap: 16rpx; }
.time { width: 120rpx; font-size: $font-size-sm; color: $text-secondary; }
.card { flex: 1; background: $card-bg; border-radius: $border-radius; padding: 16rpx; box-shadow: 0 4rpx 12rpx rgba(0,0,0,0.05); }
.c-title { font-size: $font-size-base; font-weight: bold; color: $text-primary; }
.c-sub { display: block; margin-top: 8rpx; font-size: $font-size-sm; color: $text-secondary; }
.suggest { flex: 1; background: $bg-color; border-radius: $border-radius; padding: 16rpx; }
.s-title { font-size: $font-size-base; color: $text-primary; font-weight: 500; }
.s-sub { display: block; margin-top: 8rpx; font-size: $font-size-sm; color: $text-secondary; }
</style>

