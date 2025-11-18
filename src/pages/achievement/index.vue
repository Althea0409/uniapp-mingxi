<template>
  <view class="achievement-page">
    <scroll-view scroll-y class="content">
      <Card>
        <view class="points-card">
          <view class="coin">💰</view>
          <view class="p-info">
            <text class="p-title">当前积分</text>
            <text class="p-value">{{ points }}</text>
            <text class="p-sub">今日 +50 · 本周 +320</text>
          </view>
          <Button text="积分明细" type="secondary" size="small" @click="showDetail" />
        </view>
      </Card>

      <Card>
        <text class="section-title">🏆 已获得成就 ({{ unlocked.length }}/{{ achievements.length }})</text>
        <view class="ach-list">
          <view class="ach-item" v-for="a in unlocked" :key="a.id">
            <text class="ach-icon">{{ a.icon }}</text>
            <view class="ach-info">
              <text class="ach-name">{{ a.name }}</text>
              <text class="ach-desc">奖励：+{{ a.reward }}积分 · 获得时间：{{ a.unlockTime }}</text>
            </view>
          </view>
        </view>
      </Card>

      <Card>
        <text class="section-title">⭐ 进行中成就</text>
        <view class="ach-list">
          <view class="ach-item" v-for="a in inProgress" :key="a.id">
            <text class="ach-icon">{{ a.icon }}</text>
            <view class="ach-info">
              <text class="ach-name">{{ a.name }}</text>
              <view class="metric-bar"><view class="fill" :style="{ width: ((a.progress||0)/(a.total||1))*100 + '%' }"></view></view>
              <text class="ach-desc">进度：{{ a.progress }}/{{ a.total }} · 奖励：+{{ a.reward }}积分</text>
            </view>
          </view>
        </view>
      </Card>

      <Card>
        <text class="section-title">🔒 未解锁成就</text>
        <view class="grid">
          <view class="grid-item" v-for="a in locked" :key="a.id">
            <text class="grid-icon">{{ a.icon }}</text>
            <text class="grid-name">{{ a.name }}</text>
          </view>
        </view>
      </Card>
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

const appStore = useAppStore();
const userStore = useUserStore();

const points = ref(userStore.userPoints);
const achievements = ref(achievementsJson.achievements);

const unlocked = computed(() => achievements.value.filter(a => a.status === 'unlocked'));
const inProgress = computed(() => achievements.value.filter(a => a.status === 'in-progress'));
const locked = computed(() => achievements.value.filter(a => a.status === 'locked'));

const showDetail = () => {
  appStore.showToast('积分明细功能开发中', 'none');
};
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.content { padding: 24rpx 32rpx 24rpx 32rpx; box-sizing: border-box; width: 100%; }

.points-card { display: flex; align-items: center; gap: 16rpx; }
.coin { font-size: 64rpx; }
.p-info { flex: 1; display: flex; flex-direction: column; gap: 6rpx; }
.p-title { font-size: $font-size-sm; color: $text-secondary; }
.p-value { font-size: $font-size-xl; color: $text-primary; font-weight: bold; }
.p-sub { font-size: $font-size-xs; color: $text-placeholder; }

.section-title { display: block; margin-bottom: 12rpx; font-size: $font-size-base; color: $text-primary; font-weight: 600; }
.ach-list { display: flex; flex-direction: column; gap: 12rpx; }
.ach-item { display: flex; gap: 16rpx; align-items: center; }
.ach-icon { font-size: 48rpx; }
.ach-info { flex: 1; }
.ach-name { display: block; font-size: $font-size-base; color: $text-primary; font-weight: 500; }
.ach-desc { display: block; margin-top: 6rpx; font-size: $font-size-xs; color: $text-secondary; }

.metric-bar { height: 12rpx; background: $divider-color; border-radius: 6rpx; overflow: hidden; margin-top: 8rpx; }
.fill { height: 100%; background: $gradient-primary; }

.grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16rpx; }
.grid-item { background: $bg-color; border-radius: $border-radius; padding: 16rpx; display: flex; flex-direction: column; align-items: center; gap: 8rpx; }
.grid-icon { font-size: 48rpx; }
.grid-name { font-size: $font-size-sm; color: $text-secondary; }
</style>

