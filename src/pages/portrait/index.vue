<template>
  <view class="portrait-page">
    <view class="tab-bar">
      <view v-for="(t,i) in tabs" :key="i" :class="['tab-item',{active: currentTab===i}]" @tap="currentTab=i">
        <text class="tab-text">{{ t }}</text>
      </view>
      <view class="tab-indicator" :style="{ left: `${currentTab * 25}%` }"></view>
    </view>
    <scroll-view scroll-y class="content-area">
      <view class="subject-tabs">
        <text v-for="s in subjects" :key="s" :class="['subject-tab', { active: subject===s }]" @tap="switchSubject(s)">{{ s }}</text>
      </view>
      <view v-if="currentTab===0" class="section">
        <Card>
          <view class="section-header">
            <text class="section-title">学习行为分析</text>
            <view class="section-actions">
              <text class="action">分析完成</text>
              <text class="action">基于你的学习数据</text>
            </view>
          </view>
        </Card>
        <view class="grid">
          <Card>
            <view class="stat-block">
              <text class="block-title">学习时长统计</text>
              <view class="stat-row">
                <text class="stat-label">日均学习时长</text>
                <text class="stat-value primary">{{ stats.dailyHours }}小时</text>
              </view>
              <view class="stat-row">
                <text class="stat-label">本周总时长</text>
                <text class="stat-value success">{{ stats.weekHours }}小时</text>
              </view>
              <view class="stat-row">
                <text class="stat-label">专注度评分</text>
                <text class="stat-value warning">{{ stats.focusScore }}%</text>
              </view>
            </view>
          </Card>
          <Card>
            <view class="stat-block">
              <text class="block-title">学习习惯分析</text>
              <view class="habit-row">
                <text class="habit-label">最佳学习时段</text>
                <text class="habit-tag">{{ habits.bestPeriod }}</text>
              </view>
              <view class="habit-row">
                <text class="habit-label">学习连续性</text>
                <text :class="['habit-badge', habits.continuity.level]">{{ habits.continuity.text }}</text>
              </view>
              <view class="habit-row">
                <text class="habit-label">复习频率</text>
                <text :class="['habit-badge', habits.review.level]">{{ habits.review.text }}</text>
              </view>
            </view>
          </Card>
        </view>
        <Card>
          <view class="chart-placeholder">
            <text class="chart-title">学习行为趋势图表</text>
            <text class="chart-desc">显示最近30天的学习行为变化</text>
          </view>
        </Card>
      </view>
      <view v-if="currentTab===1" class="section">
        <Card>
          <view class="section-header">
            <text class="section-title">技能图谱分析</text>
            <view class="section-actions">
              <text class="action">技能评价</text>
              <text class="action">你的语文能力画像</text>
            </view>
          </view>
        </Card>
        <view class="summary-grid">
          <Card><view class="summary"><text class="summary-num success">{{ skills.advantage }}</text><text class="summary-label">优势技能</text></view></Card>
          <Card><view class="summary"><text class="summary-num warning">{{ skills.toImprove }}</text><text class="summary-label">待提升技能</text></view></Card>
          <Card><view class="summary"><text class="summary-num primary">{{ skills.mastery }}%</text><text class="summary-label">平均掌握度</text></view></Card>
        </view>
        <Card>
          <view class="sub-section">
            <text class="sub-title">语文核心技能</text>
            <view class="bar" v-for="item in coreSkills" :key="item.name">
              <text class="bar-label">{{ item.name }}</text>
              <view class="bar-track"><view class="bar-fill" :style="{ width: item.value + '%' }"></view></view>
              <text class="bar-value">{{ item.value }}%</text>
            </view>
          </view>
        </Card>
        <Card>
          <view class="sub-section">
            <text class="sub-title">语文应用技能</text>
            <view class="bar" v-for="item in appliedSkills" :key="item.name">
              <text class="bar-label">{{ item.name }}</text>
              <view class="bar-track"><view class="bar-fill" :style="{ width: item.value + '%' }"></view></view>
              <text class="bar-value">{{ item.value }}%</text>
            </view>
          </view>
        </Card>
        <Card>
          <view class="chart-placeholder">
            <text class="chart-title">技能关系图谱</text>
            <text class="chart-desc">展示技能之间的关联与依赖</text>
          </view>
        </Card>
      </view>
      <view v-if="currentTab===2" class="section">
        <Card>
          <view class="section-header">
            <text class="section-title">知识图谱分析</text>
            <view class="section-actions">
              <text class="action">分析完成</text>
              <text class="action">智能知识点诊断</text>
            </view>
          </view>
        </Card>
        <view class="summary-grid">
          <Card><view class="summary"><text class="summary-num success">{{ knowledge.mastered }}</text><text class="summary-label">已掌握知识点</text></view></Card>
          <Card><view class="summary"><text class="summary-num info">{{ knowledge.learning }}</text><text class="summary-label">学习中知识点</text></view></Card>
          <Card><view class="summary"><text class="summary-num warning">{{ knowledge.weak }}</text><text class="summary-label">薄弱知识点</text></view></Card>
          <Card><view class="summary"><text class="summary-num primary">{{ knowledge.overall }}%</text><text class="summary-label">整体掌握度</text></view></Card>
        </view>
        <Card>
          <view class="sub-section">
            <text class="sub-title">文言文知识体系</text>
            <view class="bar" v-for="item in classicKnowledge" :key="item.name">
              <text class="bar-label">{{ item.name }}</text>
              <view class="bar-track"><view class="bar-fill" :style="{ width: item.value + '%' }"></view></view>
              <text class="bar-value">{{ item.value }}%</text>
            </view>
          </view>
        </Card>
        <Card>
          <view class="sub-section">
            <text class="sub-title">现代文知识体系</text>
            <view class="bar" v-for="item in modernKnowledge" :key="item.name">
              <text class="bar-label">{{ item.name }}</text>
              <view class="bar-track"><view class="bar-fill" :style="{ width: item.value + '%' }"></view></view>
              <text class="bar-value">{{ item.value }}%</text>
            </view>
          </view>
        </Card>
        <Card>
          <view class="chart-placeholder">
            <text class="chart-title">知识关联图谱</text>
            <text class="chart-desc">展示知识点之间的内在联系</text>
          </view>
        </Card>
      </view>
      <view v-if="currentTab===3" class="section">
        <Card>
          <view class="section-header">
            <text class="section-title">资源推荐</text>
            <view class="section-actions">
              <text class="action">为你推荐</text>
            </view>
          </view>
        </Card>
        <Card v-for="res in resources" :key="res.id">
          <view class="res-item">
            <view class="res-icon">{{ res.icon }}</view>
            <view class="res-content">
              <text class="res-title">{{ res.title }}</text>
              <text class="res-desc">{{ res.desc }}</text>
              <view class="res-tags">
                <text class="res-tag">匹配度 {{ res.match }}%</text>
                <text class="res-tag">类型 {{ res.type }}</text>
              </view>
            </view>
            <Button text="查看" type="secondary" size="small" />
          </view>
        </Card>
      </view>
    </scroll-view>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import Card from '@/components/common/Card.vue';
import Button from '@/components/common/Button.vue';
import portraitData from '@/mock/portrait.json';

const tabs = ['学习行为分析','技能图谱','知识图谱','资源推荐'];
const subjects = ['语文','数学','英语','物理'];
const currentTab = ref(0);
const subject = ref('语文');

const dataBySubject = portraitData as Record<string, any>;

const stats = ref(dataBySubject[subject.value].stats);
const habits = ref(dataBySubject[subject.value].habits);
const skills = ref(dataBySubject[subject.value].skills);
const coreSkills = ref(dataBySubject[subject.value].coreSkills);
const appliedSkills = ref(dataBySubject[subject.value].appliedSkills);
const knowledge = ref(dataBySubject[subject.value].knowledge);
const classicKnowledge = ref(dataBySubject[subject.value].classicKnowledge);
const modernKnowledge = ref(dataBySubject[subject.value].modernKnowledge);
const resources = ref(dataBySubject[subject.value].resources);

const switchSubject = (s: string) => {
  subject.value = s;
  const d = dataBySubject[s];
  stats.value = d.stats; habits.value = d.habits; skills.value = d.skills;
  coreSkills.value = d.coreSkills; appliedSkills.value = d.appliedSkills;
  knowledge.value = d.knowledge; classicKnowledge.value = d.classicKnowledge; modernKnowledge.value = d.modernKnowledge;
  resources.value = d.resources;
};
</script>


<style lang="scss" scoped>
@import '@/styles/variables.scss';

.portrait-page { min-height: 100vh; background-color: $bg-color; display: flex; flex-direction: column; }
.tab-bar { position: relative; display: flex; background-color: $card-bg; padding: 0 32rpx; box-shadow: 0 2rpx 8rpx rgba(0,0,0,0.05); }
.tab-item { flex: 1; display: flex; align-items: center; justify-content: center; height: 88rpx; }
.tab-text { font-size: $font-size-base; color: $text-secondary; font-weight: 500; transition: $transition-fast; }
.tab-item.active .tab-text { color: $primary-color; font-weight: bold; }
.tab-indicator { position: absolute; bottom: 0; left: 0; width: 25%; height: 6rpx; background: $gradient-primary; border-radius: 3rpx 3rpx 0 0; transition: left 0.3s ease; }
.content-area { flex: 1; padding: 24rpx 32rpx; box-sizing: border-box; }

.subject-tabs { display: flex; gap: 12rpx; margin-bottom: 16rpx; }
.subject-tab { padding: 8rpx 16rpx; background: $bg-color; border-radius: 24rpx; font-size: $font-size-xs; color: $text-secondary; }
.subject-tab.active { background: $card-bg; color: $primary-color; font-weight: bold; box-shadow: 0 4rpx 12rpx rgba(0,0,0,0.05); }

.section { display: flex; flex-direction: column; gap: 24rpx; }
.section-header { display: flex; align-items: center; justify-content: space-between; }
.section-title { font-size: $font-size-lg; font-weight: bold; color: $text-primary; }
.section-actions { display: flex; gap: 12rpx; }
.action { padding: 8rpx 16rpx; background: $bg-color; border-radius: 24rpx; font-size: $font-size-xs; color: $primary-color; }

.grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 24rpx; }
.stat-block { display: flex; flex-direction: column; gap: 16rpx; }
.block-title { font-size: $font-size-base; font-weight: 600; color: $text-primary; margin-bottom: 8rpx; }
.stat-row { display: flex; align-items: center; justify-content: space-between; }
.stat-label { font-size: $font-size-sm; color: $text-secondary; }
.stat-value { font-size: $font-size-lg; font-weight: bold; }
.stat-value.primary { color: $primary-color; }
.stat-value.success { color: $success-color; }
.stat-value.warning { color: $warning-color; }

.habit-row { display: flex; align-items: center; justify-content: space-between; margin-bottom: 12rpx; }
.habit-label { font-size: $font-size-sm; color: $text-secondary; }
.habit-tag { padding: 8rpx 16rpx; background: $bg-color; border-radius: 24rpx; font-size: $font-size-xs; color: $text-primary; }
.habit-badge { padding: 8rpx 16rpx; border-radius: 24rpx; font-size: $font-size-xs; font-weight: bold; }
.habit-badge.good { background-color: rgba(82, 196, 26, 0.1); color: $success-color; }
.habit-badge.warn { background-color: rgba(250, 173, 20, 0.1); color: $warning-color; }

.chart-placeholder { display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 8rpx; padding: 48rpx 0; background: #F7FAFF; border-radius: $border-radius; }
.chart-title { font-size: $font-size-base; color: $text-primary; }
.chart-desc { font-size: $font-size-sm; color: $text-secondary; }

.summary-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 24rpx; }
.summary { display: flex; flex-direction: column; align-items: center; gap: 8rpx; }
.summary-num { font-size: $font-size-xl; font-weight: bold; }
.summary-num.primary { color: $primary-color; }
.summary-num.success { color: $success-color; }
.summary-num.warning { color: $warning-color; }
.summary-num.info { color: $info-color; }
.summary-label { font-size: $font-size-sm; color: $text-secondary; }

.sub-section { display: flex; flex-direction: column; gap: 12rpx; }
.sub-title { font-size: $font-size-base; font-weight: 600; color: $text-primary; }
.bar { display: grid; grid-template-columns: 1fr auto auto; align-items: center; gap: 12rpx; }
.bar-label { font-size: $font-size-sm; color: $text-secondary; }
.bar-track { height: 12rpx; background-color: $divider-color; border-radius: 6rpx; overflow: hidden; }
.bar-fill { height: 100%; background: $gradient-primary; }
.bar-value { font-size: $font-size-xs; color: $text-primary; }

.res-item { display: flex; align-items: center; gap: 16rpx; }
.res-icon { font-size: 44rpx; }
.res-content { flex: 1; display: flex; flex-direction: column; gap: 6rpx; }
.res-title { font-size: $font-size-base; color: $text-primary; font-weight: 600; }
.res-desc { font-size: $font-size-sm; color: $text-secondary; }
.res-tags { display: flex; gap: 12rpx; }
.res-tag { padding: 6rpx 12rpx; background: $bg-color; border-radius: 16rpx; font-size: $font-size-xs; color: $text-secondary; }
</style>