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
              <view class="ach-row">
                <text class="ach-desc">进度：{{ a.progress }}/{{ a.total }} · 奖励：+{{ a.reward }}积分</text>
                <Button v-if="canClaim(a)" text="领取奖励" type="primary" size="small" @click="claim(a)" />
              </view>
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

      <view v-if="celebrate" class="celebrate-mask" @tap="celebrate=false">
        <view class="celebrate-card">
          <text class="celebrate-emoji">🎉</text>
          <text class="celebrate-text">已解锁成就，积分+{{ lastReward }}</text>
          <Button text="太棒了" type="primary" size="small" @click="celebrate=false" />
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
const stored = (storage.get(StorageKeys.ACHIEVEMENTS) as any) || achievementsJson.achievements;
const achievements = ref<any[]>(stored);
const logs = ((storage.get(StorageKeys.GROWTH_LOG) as any) || []) as any[];

const unlocked = computed(() => achievements.value.filter(a => a.status === 'unlocked'));
const inProgress = computed(() => achievements.value.filter(a => a.status === 'in-progress'));
const locked = computed(() => achievements.value.filter(a => a.status === 'locked'));
const resources = computed(() => (achievementsJson as any).resources || []);

const todayDelta = computed(() => {
  const now = new Date();
  const y = now.getFullYear();
  const m = now.getMonth();
  const d = now.getDate();
  return logs.filter(x => x.type==='points').filter(x => {
    const t = new Date(x.at);
    return t.getFullYear()===y && t.getMonth()===m && t.getDate()===d;
  }).reduce((s,x)=> s + (x.delta||0), 0);
});
const weekDelta = computed(() => {
  const now = new Date();
  const day = now.getDay() || 7;
  const start = new Date(now.getFullYear(), now.getMonth(), now.getDate() - (day - 1));
  return logs.filter(x => x.type==='points').filter(x => x.at >= start.getTime()).reduce((s,x)=> s + (x.delta||0), 0);
});

const showDetail = () => {
  uni.navigateTo({ url: '/pages/growth/index?tab=points' });
};
const goGrowth = () => {
  uni.navigateTo({ url: '/pages/growth/index' });
};

const canClaim = (a: any) => (a.status==='in-progress') && (a.progress>=a.total);
const celebrate = ref(false);
const lastReward = ref(0);
const claim = (a: any) => {
  if (!canClaim(a)) return;
  a.status = 'unlocked';
  a.unlockTime = new Date().toISOString().slice(0,10);
  storage.set(StorageKeys.ACHIEVEMENTS, achievements.value);
  userStore.addPoints(a.reward||0);
  points.value = userStore.userPoints;
  lastReward.value = a.reward||0;
  appStore.triggerEncouragement('celebration');
  celebrate.value = true;
};

const openResource = (r: any) => {
  uni.navigateTo({ url: `/pages/discover/resource-detail?id=${r.id}` });
};
const mapTypeIcon = (t: string) => {
  if (t==='video') return '🎬';
  if (t==='audio') return '🎧';
  if (t==='exercise') return '📝';
  return '📄';
};

const confettiStyle = (i: number) => {
  const left = Math.random()*90 + '%';
  const delay = (Math.random()*0.6).toFixed(2) + 's';
  const duration = (1.8 + Math.random()*0.8).toFixed(2) + 's';
  const size = (24 + Math.random()*12).toFixed(0) + 'rpx';
  return { left, animationDelay: delay, animationDuration: duration, fontSize: size } as any;
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
.ach-row { margin-top: 8rpx; display:flex; align-items:center; justify-content: space-between; gap: 12rpx; }

.metric-bar { height: 12rpx; background: $divider-color; border-radius: 6rpx; overflow: hidden; margin-top: 8rpx; }
.fill { height: 100%; background: $gradient-primary; }

.grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16rpx; }
.grid-item { background: $bg-color; border-radius: $border-radius; padding: 16rpx; display: flex; flex-direction: column; align-items: center; gap: 8rpx; }
.grid-icon { font-size: 48rpx; }
.grid-name { font-size: $font-size-sm; color: $text-secondary; }

.res-list { display:flex; flex-direction:column; gap:12rpx; }
.res-item { display:flex; align-items:center; gap:12rpx; }
.res-icon { font-size:40rpx; }
.res-info { flex:1; display:flex; flex-direction:column; }
.res-title { font-size:$font-size-base; color:$text-primary; font-weight:600; }
.res-desc { font-size:$font-size-xs; color:$text-secondary; }

.celebrate-mask { position: fixed; inset: 0; background: rgba(0,0,0,0.35); z-index: $z-index-modal; }
.celebrate-card { position:absolute; left:50%; top:30%; transform: translateX(-50%); width: 70%; background:#FFFFFF; border-radius:$border-radius; padding:24rpx; display:flex; flex-direction:column; align-items:center; gap:12rpx; box-shadow:0 8rpx 24rpx rgba(0,0,0,0.2); }
.celebrate-emoji { font-size:64rpx; }
.celebrate-text { font-size:$font-size-base; color:$text-primary; }
.confetti { position:absolute; top:0; animation-name: fall; animation-timing-function: ease-in; color:#FFB84D; }
@keyframes fall { 0% { transform: translateY(-10%); opacity:1; } 100% { transform: translateY(120%); opacity:0; } }
</style>
