<template>
  <view class="achievement-page">
    <scroll-view scroll-y class="content">
      <Card>
        <view class="points-card">
          <view class="coin">💰</view>
          <view class="p-info">
            <text class="p-title">当前积分</text>
            <text class="p-value">{{ points }}</text>
            <text class="p-sub">今日 +{{ todayDelta }} · 本周 +{{ weekDelta }}</text>
          </view>
          <Button text="积分明细" type="secondary" size="small" @click="showDetail" />
          <Button text="查看成长档案" type="primary" size="small" @click="goGrowth" />
        </view>
      </Card>

      <Card>
        <view class="level-card">
          <view class="level-left">
            <text class="level-badge">🏆</text>
            <view class="level-info">
              <text class="level-title">成就等级</text>
              <text class="level-name">{{ levelName }}</text>
            </view>
          </view>
          <view class="level-right">
            <view class="level-bar">
              <view class="level-fill" :style="{ width: levelPercent + '%' }"></view>
            </view>
            <text class="level-text">{{ userExp }}/{{ nextExp }} EXP</text>
          </view>
        </view>
      </Card>



      <Card>
        <view class="medal-header">
          <text class="section-title">🎖️ 勋章墙</text>
          <scroll-view scroll-x class="tabs">
            <text v-for="t in tabs" :key="t" :class="['tab', { active: curTab === t }]" @tap="curTab = t">{{ t }}</text>
          </scroll-view>
          <scroll-view scroll-x class="status-tabs">
            <text v-for="s in statusTabs" :key="s" :class="['chip', { active: curStatus === s }]"
              @tap="curStatus = s">{{ s
              }}</text>
          </scroll-view>
        </view>
        <view class="medal-grid">
          <view class="medal-item" v-for="a in filteredMedals" :key="a.id" @tap="openMedal(a)"
            :class="[a.status, a.rarity]">
            <view class="medal-icon">{{ a.icon }}</view>
            <view class="medal-name">{{ a.name }}</view>
            <view class="medal-extra">
              <text class="rarity-tag" v-if="a.rarity === 'epic'">传说</text>
              <text class="rarity-tag" v-else-if="a.rarity === 'rare'">稀有</text>
              <text class="rarity-tag" v-else>普通</text>
            </view>
            <view class="medal-progress" v-if="a.status === 'in-progress'">
              <view class="medal-bar">
                <view class="medal-fill" :style="{ width: ((a.progress || 0) / (a.total || 1)) * 100 + '%' }"></view>
              </view>
              <text class="medal-percent">{{ a.progress || 0 }}/{{ a.total || 0 }}</text>
            </view>
            <view class="lock" v-if="a.status === 'locked'">🔒</view>
          </view>
        </view>
      </Card>

      <Card>
        <text class="section-title">🎯 学习挑战与资源</text>
        <view class="res-list">
          <view class="res-item" v-for="r in resources" :key="r.id" @tap="openResource(r)">
            <text class="res-icon">{{ mapTypeIcon(r.type) }}</text>
            <view class="res-info">
              <text class="res-title">{{ r.title }}</text>
              <text class="res-desc">匹配度 {{ r.matchRate }}% · {{ r.description }}</text>
            </view>
            <Button text="去学习" type="secondary" size="small" />
          </view>
        </view>
      </Card>

      <view v-if="celebrate" class="celebrate-mask" @tap="celebrate = false">
        <view class="celebrate-card">
          <text class="celebrate-emoji">🎉</text>
          <text class="celebrate-text">已解锁成就，积分+{{ lastReward }}</text>
          <Button text="太棒了" type="primary" size="small" @click="celebrate = false" />
        </view>
        <view class="confetti" v-for="i in 24" :key="i" :style="confettiStyle(i)">✨</view>
      </view>
    </scroll-view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import Card from '@/components/common/Card.vue';
import Button from '@/components/common/Button.vue';
import { useAppStore } from '@/stores/app';
import { useUserStore } from '@/stores/user';
import achievementsJson from '@/mock/achievements.json';
import { storage, StorageKeys } from '@/utils/storage';

const appStore = useAppStore();
const userStore = useUserStore();

const points = ref(userStore.userPoints);
const userLevel = computed(() => userStore.userLevel);
const userExp = computed(() => userStore.userExp);
const nextExp = computed(() => 100);
const levelPercent = computed(() => Math.min(100, Math.round((userExp.value / nextExp.value) * 100)));
const levelName = computed(() => {
  if (userLevel.value >= 10) return '传奇学员';
  if (userLevel.value >= 7) return '高级学员';
  if (userLevel.value >= 4) return '进阶学员';
  return '见习学员';
});
const stored = (storage.get(StorageKeys.ACHIEVEMENTS) as any) || achievementsJson.achievements;
const achievements = ref<any[]>(stored);
const logs = ((storage.get(StorageKeys.GROWTH_LOG) as any) || []) as any[];

const unlocked = computed(() => achievements.value.filter(a => a.status === 'unlocked'));
const inProgress = computed(() => achievements.value.filter(a => a.status === 'in-progress'));
const locked = computed(() => achievements.value.filter(a => a.status === 'locked'));
const tabs = ['全部', '习惯', '作业', '互动', '考试', '效率'];
const curTab = ref('全部');
const curStatus = ref('全部');
const filteredMedals = computed(() => {
  let list = achievements.value;
  if (curTab.value !== '全部') list = list.filter(a => a.category === curTab.value);
  if (curStatus.value === '已解锁') list = list.filter(a => a.status === 'unlocked');
  else if (curStatus.value === '进行中') list = list.filter(a => a.status === 'in-progress');
  else if (curStatus.value === '未解锁') list = list.filter(a => a.status === 'locked');
  return list;
});
const resources = computed(() => (achievementsJson as any).resources || []);

const todayDelta = computed(() => {
  const now = new Date();
  const y = now.getFullYear();
  const m = now.getMonth();
  const d = now.getDate();
  return logs.filter(x => x.type === 'points').filter(x => {
    const t = new Date(x.at);
    return t.getFullYear() === y && t.getMonth() === m && t.getDate() === d;
  }).reduce((s, x) => s + (x.delta || 0), 0);
});
const weekDelta = computed(() => {
  const now = new Date();
  const day = now.getDay() || 7;
  const start = new Date(now.getFullYear(), now.getMonth(), now.getDate() - (day - 1));
  return logs.filter(x => x.type === 'points').filter(x => x.at >= start.getTime()).reduce((s, x) => s + (x.delta || 0), 0);
});

const showDetail = () => {
  uni.navigateTo({ url: '/pages/growth/index?tab=points' });
};
const goGrowth = () => {
  uni.navigateTo({ url: '/pages/growth/index' });
};

const canClaim = (a: any) => (a.status === 'in-progress') && (a.progress >= a.total);
const celebrate = ref(false);
const lastReward = ref(0);
const claim = (a: any) => {
  if (!canClaim(a)) return;
  a.status = 'unlocked';
  a.unlockTime = new Date().toISOString().slice(0, 10);
  storage.set(StorageKeys.ACHIEVEMENTS, achievements.value);
  userStore.addPoints(a.reward || 0);
  points.value = userStore.userPoints;
  lastReward.value = a.reward || 0;
  appStore.triggerEncouragement('celebration');
  celebrate.value = true;
};

const openMedal = (a: any) => {
  if (a.status === 'locked') return;
  if (a.status === 'in-progress') return;
  appStore.triggerEncouragement('celebration');
  celebrate.value = true;
  lastReward.value = a.reward || 0;
};

const openResource = (r: any) => {
  uni.navigateTo({ url: `/pages/discover/resource-detail?id=${r.id}` });
};
const mapTypeIcon = (t: string) => {
  if (t === 'video') return '🎬';
  if (t === 'audio') return '🎧';
  if (t === 'exercise') return '📝';
  return '📄';
};

const confettiStyle = (i: number) => {
  const left = Math.random() * 90 + '%';
  const delay = (Math.random() * 0.6).toFixed(2) + 's';
  const duration = (1.8 + Math.random() * 0.8).toFixed(2) + 's';
  const size = (24 + Math.random() * 12).toFixed(0) + 'rpx';
  return { left, animationDelay: delay, animationDuration: duration, fontSize: size } as any;
};
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.content {
  padding: 24rpx 32rpx 24rpx 32rpx;
  box-sizing: border-box;
  width: 100%;
}

.points-card {
  display: flex;
  align-items: center;
  gap: 16rpx;
}

.coin {
  font-size: 64rpx;
}

.p-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 6rpx;
}

.p-title {
  font-size: $font-size-sm;
  color: $text-secondary;
}

.p-value {
  font-size: $font-size-xl;
  color: $text-primary;
  font-weight: bold;
}

.p-sub {
  font-size: $font-size-xs;
  color: $text-placeholder;
}

.section-title {
  display: block;
  margin-bottom: 12rpx;
  font-size: $font-size-base;
  color: $text-primary;
  font-weight: 600;
}

.ach-list {
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}

.ach-item {
  display: flex;
  gap: 16rpx;
  align-items: center;
}

.ach-icon {
  font-size: 48rpx;
}

.ach-info {
  flex: 1;
}

.ach-name {
  display: block;
  font-size: $font-size-base;
  color: $text-primary;
  font-weight: 500;
}

.ach-desc {
  display: block;
  margin-top: 6rpx;
  font-size: $font-size-xs;
  color: $text-secondary;
}

.ach-row {
  margin-top: 8rpx;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12rpx;
}

.metric-bar {
  height: 12rpx;
  background: $divider-color;
  border-radius: 6rpx;
  overflow: hidden;
  margin-top: 8rpx;
}

.fill {
  height: 100%;
  background: $gradient-primary;
}

.medal-header {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 8rpx;
}

.tabs {
  display: flex;
  flex-wrap: nowrap;
  gap: 24rpx;
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
  padding-bottom: 4rpx;
}

.tab {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  flex: 0 0 auto;
  font-size: $font-size-sm;
  color: $text-secondary;
  padding: 8rpx 16rpx;
  background: $bg-color;
  border-radius: 999rpx;
}

.tab.active {
  color: #fff;
  background: #2B46FE;
}

.medal-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16rpx;
}

.medal-item {
  position: relative;
  background: #fff;
  border-radius: $border-radius;
  padding: 16rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8rpx;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.06);
  min-height: 200rpx;
}

.medal-item.unlocked {
  box-shadow: 0 6rpx 16rpx rgba(43, 70, 254, 0.2);
}

.medal-item.locked {
  opacity: 0.6;
}

.medal-item.epic {
  border: 2rpx solid #ff7bb4;
}

.medal-item.rare {
  border: 2rpx solid #7b61ff;
}

.medal-icon {
  font-size: 56rpx;
}

.medal-name {
  font-size: $font-size-sm;
  color: $text-primary;
  font-weight: 600;
  text-align: center;
}

.medal-extra {
  display: flex;
  align-items: center;
  gap: 6rpx;
}

.rarity-tag {
  font-size: $font-size-xs;
  color: #fff;
  background: #999;
  border-radius: 999rpx;
  padding: 4rpx 8rpx;
}

.medal-item.epic .rarity-tag {
  background: #ff7bb4;
}

.medal-item.rare .rarity-tag {
  background: #7b61ff;
}

.medal-progress {
  width: 100%;
  display: flex;
  align-items: center;
  gap: 8rpx;
}

.medal-bar {
  flex: 1;
  height: 10rpx;
  background: $divider-color;
  border-radius: 999rpx;
  overflow: hidden;
}

.medal-fill {
  height: 100%;
  background: $gradient-primary;
}

.medal-percent {
  font-size: $font-size-xs;
  color: $text-secondary;
}

.lock {
  position: absolute;
  right: 12rpx;
  top: 12rpx;
}

.res-list {
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}

.res-item {
  display: flex;
  align-items: center;
  gap: 12rpx;
}

.res-icon {
  font-size: 40rpx;
}

.res-info {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.res-title {
  font-size: $font-size-base;
  color: $text-primary;
  font-weight: 600;
}

.res-desc {
  font-size: $font-size-xs;
  color: $text-secondary;
}

.celebrate-mask {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.35);
  z-index: $z-index-modal;
}

.celebrate-card {
  position: absolute;
  left: 50%;
  top: 30%;
  transform: translateX(-50%);
  width: 70%;
  background: #FFFFFF;
  border-radius: $border-radius;
  padding: 24rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12rpx;
  box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.2);
}

.celebrate-emoji {
  font-size: 64rpx;
}

.celebrate-text {
  font-size: $font-size-base;
  color: $text-primary;
}

.confetti {
  position: absolute;
  top: 0;
  animation-name: fall;
  animation-timing-function: ease-in;
  color: #FFB84D;
}

@keyframes fall {
  0% {
    transform: translateY(-10%);
    opacity: 1;
  }

  100% {
    transform: translateY(120%);
    opacity: 0;
  }
}

.level-card {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16rpx;
}

.level-left {
  display: flex;
  align-items: center;
  gap: 12rpx;
}

.level-badge {
  font-size: 48rpx;
}

.level-info {
  display: flex;
  flex-direction: column;
}

.level-title {
  font-size: $font-size-sm;
  color: $text-secondary;
}

.level-name {
  font-size: $font-size-base;
  color: $text-primary;
  font-weight: 600;
}

.level-right {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 8rpx;
  width: 50%;
}

.level-bar {
  height: 12rpx;
  background: $divider-color;
  border-radius: 6rpx;
  overflow: hidden;
  width: 100%;
}

.level-fill {
  height: 100%;
  background: $gradient-primary;
}

.level-text {
  font-size: $font-size-xs;
  color: $text-secondary;
}

.status-tabs {
  display: flex;
  flex-wrap: nowrap;
  gap: 20rpx;
  margin: 4rpx 0 12rpx 0;
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
}

.chip {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  flex: 0 0 auto;
  font-size: $font-size-xs;
  color: $text-secondary;
  padding: 6rpx 12rpx;
  background: $bg-color;
  border-radius: 999rpx;
}

.chip.active {
  color: #fff;
  background: #2B46FE;
}
</style>
