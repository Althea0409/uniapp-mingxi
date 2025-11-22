<template>
  <view class="schedule-page">
    <view class="week-selector">
      <text class="arrow" @tap="prevWeek">‹</text>
      <text class="week-text">第{{ week }}周 ({{ weekRangeText }})</text>
      <text class="arrow" @tap="nextWeek">›</text>
    </view>

    <scroll-view class="day-tabs" scroll-x>
      <view class="day-row">
        <view v-for="d in days" :key="d.full" :class="['day-item', { current: d.isSelected }]" @tap="selectDay(d.full)">
          <text class="day-week">{{ d.week }}</text>
          <text class="day-date">{{ d.date }}</text>
        </view>
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
import { ref, computed } from 'vue';

const now = new Date();
const semStart = (() => {
  const y = now.getMonth() >= 8 ? now.getFullYear() : now.getFullYear() - 1;
  return new Date(y, 8, 1);
})();
const weekOffset = ref(0);
const baseDate = computed(() => {
  const d = new Date(now);
  d.setDate(d.getDate() + weekOffset.value * 7);
  return d;
});
const week = computed(() => Math.max(1, Math.ceil((+baseDate.value - +semStart) / (7 * 24 * 3600 * 1000))));
function rangeOfWeek(d: Date) {
  const w = d.getDay() || 7;
  const mon = new Date(d.getFullYear(), d.getMonth(), d.getDate() - (w - 1));
  const sun = new Date(mon);
  sun.setDate(mon.getDate() + 6);
  return { mon, sun };
}
const weekRangeText = computed(() => {
  const { mon, sun } = rangeOfWeek(baseDate.value);
  const m1 = String(mon.getMonth() + 1).padStart(2, '0');
  const d1 = String(mon.getDate()).padStart(2, '0');
  const m2 = String(sun.getMonth() + 1).padStart(2, '0');
  const d2 = String(sun.getDate()).padStart(2, '0');
  return `${m1}/${d1}-${m2}/${d2}`;
});

const selected = ref('');
const days = ref<any[]>([]);
function genDays() {
  const { mon } = rangeOfWeek(baseDate.value);
  const arr = [] as any[];
  const names = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
  for (let i = 0; i < 7; i++) {
    const d = new Date(mon);
    d.setDate(mon.getDate() + i);
    const full = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
    arr.push({ week: names[i], date: String(d.getDate()), full, isSelected: false });
  }
  days.value = arr;
  const todayFull = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`;
  selected.value = arr.some(x => x.full === todayFull) ? todayFull : arr[0].full;
  days.value = days.value.map(x => ({ ...x, isSelected: x.full === selected.value }));
}

const times = ['08:00', '09:00', '10:00', '11:00', '14:00', '15:00'];
const table: Record<number, string[]> = {
  1: ['语文', '数学', '英语', '科学', '历史与社会', '体育'],
  2: ['数学', '语文', '英语', '科学', '道德与法治', '音乐'],
  3: ['英语', '数学', '语文', '科学', '历史与社会', '美术'],
  4: ['科学', '语文', '数学', '英语', '道德与法治', '信息技术'],
  5: ['语文', '数学', '英语', '科学', '综合实践', '班会'],
  6: ['体育', '语文', '数学', '英语', '科学', '劳动'],
  7: ['自习', '阅读', '写作', '数学巩固', '英语口语', '体育活动']
};
const teacherMap: Record<string, string> = {
  '语文': '李老师', '数学': '王老师', '英语': '刘老师', '科学': '陈老师', '历史与社会': '赵老师', '道德与法治': '周老师', '体育': '孙老师', '音乐': '吴老师', '美术': '郑老师', '信息技术': '钱老师', '综合实践': '唐老师', '班会': '班主任', '劳动': '胡老师', '自习': '值班老师', '阅读': '图书馆老师', '写作': '语文老师', '数学巩固': '数学老师', '英语口语': '英语老师', '体育活动': '体育老师'
};
function roomOf(subject: string) {
  if (subject === '体育' || subject === '体育活动') return '操场';
  if (subject === '音乐') return '艺术楼M-203';
  if (subject === '美术') return '艺术楼A-105';
  if (subject === '信息技术') return '信息楼I-202';
  return '教学楼A-201';
}

const schedule = ref<any[]>([]);
function genSchedule(full: string) {
  const d = new Date(full);
  const idx = (d.getDay() || 7);
  const subjects = table[idx] || [];
  const isEvenWeek = week.value % 2 === 0;
  const alt = isEvenWeek && idx === 5 ? [...subjects.slice(0, 5), '社团活动'] : subjects;
  schedule.value = alt.slice(0, times.length).map((s, i) => ({
    startTime: times[i],
    courseName: `${s}·七年级（浙教版）`,
    location: roomOf(s),
    teacher: teacherMap[s] || '老师'
  }));
}

function selectDay(full: string) {
  selected.value = full;
  days.value = days.value.map(x => ({ ...x, isSelected: x.full === selected.value }));
  genSchedule(full);
}

function prevWeek() { weekOffset.value--; genDays(); genSchedule(selected.value); }
function nextWeek() { weekOffset.value++; genDays(); genSchedule(selected.value); }

genDays();
genSchedule(selected.value);
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.schedule-page {
  padding: 24rpx 32rpx;
}

.week-selector {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 24rpx;
  margin-bottom: 16rpx;
}

.arrow {
  font-size: 40rpx;
  cursor: pointer;
}

.week-text {
  font-size: $font-size-base;
  color: $text-primary;
}

.day-tabs {
  padding: 8rpx 0 16rpx;
}

.day-row {
  display: flex;
  gap: 16rpx;
}

.day-item {
  flex: 0 0 auto;
  width: 96rpx;
  height: 88rpx;
  background: $bg-color;
  border-radius: $border-radius;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.day-item.current {
  background: $card-bg;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.05);
}

.day-week {
  font-size: $font-size-xs;
  color: $text-secondary;
}

.day-date {
  font-size: $font-size-base;
  color: $text-primary;
  font-weight: bold;
}

.timeline {
  display: flex;
  flex-direction: column;
  gap: 24rpx;
}

.time-item {
  display: flex;
  gap: 16rpx;
}

.time {
  width: 120rpx;
  font-size: $font-size-sm;
  color: $text-secondary;
}

.card {
  flex: 1;
  background: $card-bg;
  border-radius: $border-radius;
  padding: 16rpx;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.05);
}

.c-title {
  font-size: $font-size-base;
  font-weight: bold;
  color: $text-primary;
}

.c-sub {
  display: block;
  margin-top: 8rpx;
  font-size: $font-size-sm;
  color: $text-secondary;
}

.suggest {
  flex: 1;
  background: $bg-color;
  border-radius: $border-radius;
  padding: 16rpx;
}

.s-title {
  font-size: $font-size-base;
  color: $text-primary;
  font-weight: 500;
}

.s-sub {
  display: block;
  margin-top: 8rpx;
  font-size: $font-size-sm;
  color: $text-secondary;
}
</style>
