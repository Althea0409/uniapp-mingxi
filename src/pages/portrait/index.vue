<template>
  <view class="portrait-page">
    <view class="tab-bar">
      <view v-for="(t, i) in tabs" :key="i" :class="['tab-item', { active: currentTab === i }]" @tap="currentTab = i">
        <text class="tab-text">{{ t }}</text>
      </view>
      <view class="tab-indicator" :style="{ left: `${currentTab * 25}%` }"></view>
    </view>
    <scroll-view scroll-y class="content-area">
      <view class="subject-tabs">
        <text v-for="s in subjects" :key="s" :class="['subject-tab', { active: subject === s }]"
          @tap="switchSubject(s)">{{ s }}</text>
      </view>
      <view v-if="currentTab === 0" class="section">
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
          <view class="chart-box">
            <view id="trendLineChart" class="chart-canvas"></view>
          </view>
        </Card>
      </view>
      <view v-if="currentTab === 1" class="section">
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
          <Card>
            <view class="summary"><text class="summary-num success">{{ skills.advantage }}</text><text
                class="summary-label">优势技能</text></view>
          </Card>
          <Card>
            <view class="summary"><text class="summary-num warning">{{ skills.toImprove }}</text><text
                class="summary-label">待提升技能</text></view>
          </Card>
          <Card>
            <view class="summary"><text class="summary-num primary">{{ skills.mastery }}%</text><text
                class="summary-label">平均掌握度</text></view>
          </Card>
        </view>
        <Card>
          <view class="sub-section">
            <text class="sub-title">{{ coreTitle }}</text>
            <view class="bar" v-for="item in coreSkills" :key="item.name">
              <text class="bar-label">{{ item.name }}</text>
              <view class="bar-track">
                <view class="bar-fill" :style="{ width: item.value + '%' }"></view>
              </view>
              <text class="bar-value">{{ item.value }}%</text>
            </view>
          </view>
        </Card>
        <Card>
          <view class="sub-section">
            <text class="sub-title">{{ appliedTitle }}</text>
            <view class="bar" v-for="item in appliedSkills" :key="item.name">
              <text class="bar-label">{{ item.name }}</text>
              <view class="bar-track">
                <view class="bar-fill" :style="{ width: item.value + '%' }"></view>
              </view>
              <text class="bar-value">{{ item.value }}%</text>
            </view>
          </view>
        </Card>
        <Card>
          <view class="chart-box">
            <view id="skillGraphChart" class="chart-canvas"></view>
          </view>
        </Card>
      </view>
      <view v-if="currentTab === 2" class="section">
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
          <Card>
            <view class="summary"><text class="summary-num success">{{ knowledge.mastered }}</text><text
                class="summary-label">已掌握知识点</text></view>
          </Card>
          <Card>
            <view class="summary"><text class="summary-num info">{{ knowledge.learning }}</text><text
                class="summary-label">学习中知识点</text></view>
          </Card>
          <Card>
            <view class="summary"><text class="summary-num warning">{{ knowledge.weak }}</text><text
                class="summary-label">薄弱知识点</text></view>
          </Card>
        </view>
        <Card>
          <view class="sub-section">
            <text class="sub-title">{{ knowledgeTitles[0] }}</text>
            <view class="bar" v-for="item in classicKnowledge" :key="item.name">
              <text class="bar-label">{{ item.name }}</text>
              <view class="bar-track">
                <view class="bar-fill" :style="{ width: item.value + '%' }"></view>
              </view>
              <text class="bar-value">{{ item.value }}%</text>
            </view>
          </view>
        </Card>
        <Card>
          <view class="sub-section">
            <text class="sub-title">{{ knowledgeTitles[1] }}</text>
            <view class="bar" v-for="item in modernKnowledge" :key="item.name">
              <text class="bar-label">{{ item.name }}</text>
              <view class="bar-track">
                <view class="bar-fill" :style="{ width: item.value + '%' }"></view>
              </view>
              <text class="bar-value">{{ item.value }}%</text>
            </view>
          </view>
        </Card>
        <Card>
          <view class="chart-box">
            <view id="knowledgeGraphChart" class="chart-canvas"></view>
          </view>
        </Card>
      </view>
      <view v-if="currentTab === 3" class="section">
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
              <view class="res-meta">
                <text class="res-tag">匹配度 {{ res.match }}%</text>
                <text class="res-tag">类型 {{ res.type }}</text>
                <text v-if="res.duration" class="res-tag">时长 {{ res.duration }}min</text>
                <text v-if="res.difficulty" class="res-tag">难度 {{ res.difficulty }}</text>
              </view>
              <view v-if="res.skills && res.skills.length" class="skill-tags">
                <text v-for="sk in res.skills" :key="sk" class="skill-tag">#{{ sk }}</text>
              </view>
            </view>
            <view class="res-actions">
              <Button text="查看" type="secondary" size="small" />
              <Button text="加入计划" type="primary" size="small" />
            </view>
          </view>
        </Card>
      </view>
    </scroll-view>
  </view>
</template>

<script setup lang="ts">
import { ref, onMounted, nextTick, watch, computed } from 'vue';
import * as echarts from 'echarts';
import Card from '@/components/common/Card.vue';
import Button from '@/components/common/Button.vue';
import portraitData from '@/mock/portrait.json';

const tabs = ['学习行为分析', '技能图谱', '知识图谱', '资源推荐'];
const subjects = ['语文', '数学', '英语', '科学', '社政'];
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

const titlesDict: Record<string, { core: string; applied: string; k1: string; k2: string }> = {
  '语文': { core: '语文核心技能', applied: '语文应用技能', k1: '文言文知识体系', k2: '现代文知识体系' },
  '数学': { core: '数学核心技能', applied: '数学应用技能', k1: '代数知识体系', k2: '几何知识体系' },
  '英语': { core: '英语核心技能', applied: '英语应用技能', k1: '词汇与语法体系', k2: '阅读与表达体系' },
  '科学': { core: '科学核心技能', applied: '科学应用技能', k1: '自然科学知识体系', k2: '实验方法体系' },
  '社政': { core: '社政核心技能', applied: '社政应用技能', k1: '法治与道德体系', k2: '社会认知体系' },
};
const coreTitle = computed(() => (titlesDict[subject.value] || titlesDict['语文']).core);
const appliedTitle = computed(() => (titlesDict[subject.value] || titlesDict['语文']).applied);
const knowledgeTitles = computed(() => {
  const t = titlesDict[subject.value] || titlesDict['语文'];
  return [t.k1, t.k2];
});

const trendSeries = ref<{ date: string; hours: number }[]>([]);
const skillNodes = ref<{ name: string; value: number }[]>([]);
const knowledgeNodes = ref<{ name: string; value: number }[]>([]);
const skillEdges = ref<{ source: string; target: string; weight: number }[]>([]);
const knowledgeEdges = ref<{ source: string; target: string; weight: number }[]>([]);
let skillChart: any = null;
let knowledgeChart: any = null;
let trendChart: any = null;

const switchSubject = (s: string) => {
  subject.value = s;
  const d = dataBySubject[s];
  stats.value = d.stats; habits.value = d.habits; skills.value = d.skills;
  coreSkills.value = d.coreSkills; appliedSkills.value = d.appliedSkills;
  knowledge.value = d.knowledge; classicKnowledge.value = d.classicKnowledge; modernKnowledge.value = d.modernKnowledge;
  resources.value = d.resources;
  nextTick(() => {
    if (currentTab.value === 0) updateTrendChart();
    if (currentTab.value === 1) updateSkillChart();
    if (currentTab.value === 2) updateKnowledgeChart();
  });
  fetchTrend();
  fetchSkillGraph();
  fetchKnowledgeGraph();
};

function getCanvas(id: string) {
  const el = document.getElementById(id) as HTMLCanvasElement | null;
  if (!el) return null;
  const rect = el.getBoundingClientRect();
  el.width = Math.floor(rect.width * (window.devicePixelRatio || 1));
  el.height = Math.floor(rect.height * (window.devicePixelRatio || 1));
  const ctx = el.getContext('2d');
  if (!ctx) return null;
  ctx.scale(window.devicePixelRatio || 1, window.devicePixelRatio || 1);
  return ctx;
}

function drawTrend() {
  const ctx = getCanvas('trendChart');
  if (!ctx) return;
  const rect = (ctx.canvas as HTMLCanvasElement).getBoundingClientRect();
  const w = rect.width;
  const h = rect.height;
  ctx.clearRect(0, 0, w, h);
  const margin = { l: 40, r: 16, t: 24, b: 24 };
  const data = trendSeries.value && trendSeries.value.length ? trendSeries.value : [];
  const fallback = Array.from({ length: 30 }, (_, i) => ({ hours: (Number(stats.value.dailyHours) || 1.5) + Math.sin(i / 6) * 0.5 + (Math.random() - 0.5) * 0.3 }));
  const series: number[] = (data.length ? data : fallback).map(d => Math.max(0.2, Number(Number(d.hours).toFixed(2))));
  const days = Math.max(series.length, 2);
  const maxY = Math.max(...series) + 0.5;
  const minY = 0;
  const plotW = w - margin.l - margin.r;
  const plotH = h - margin.t - margin.b;
  if (plotW <= 0 || plotH <= 0) return;
  ctx.strokeStyle = '#E5EAF3';
  ctx.lineWidth = 1;
  for (let i = 0; i <= 4; i++) {
    const y = margin.t + (plotH * i) / 4;
    ctx.beginPath();
    ctx.moveTo(margin.l, y);
    ctx.lineTo(w - margin.r, y);
    ctx.stroke();
  }
  ctx.fillStyle = '#6C7A91';
  ctx.font = '12px sans-serif';
  for (let i = 0; i <= 4; i++) {
    const val = minY + ((maxY - minY) * (4 - i)) / 4;
    const y = margin.t + (plotH * i) / 4;
    ctx.fillText(val.toFixed(1), 6, y + 4);
  }
  ctx.strokeStyle = '#3B7CFF';
  ctx.lineWidth = 2;
  ctx.beginPath();
  series.forEach((v, i) => {
    const x = margin.l + (plotW * i) / (days - 1);
    const y = margin.t + plotH - ((v - minY) / (maxY - minY)) * plotH;
    if (i === 0) ctx.moveTo(x, y); else ctx.lineTo(x, y);
  });
  ctx.stroke();
  ctx.fillStyle = 'rgba(59,124,255,0.12)';
  ctx.lineTo(margin.l + plotW, margin.t + plotH);
  ctx.lineTo(margin.l, margin.t + plotH);
  ctx.closePath();
  ctx.fill();
}

// 使用本地依赖的 ECharts

async function initTrendChart() {
  const el = document.getElementById('trendLineChart');
  if (!el) return;
  trendChart = trendChart || echarts.init(el as HTMLDivElement);
}

async function updateTrendChart() {
  await initTrendChart();
  if (!trendChart) return;
  const fallback = Array.from({ length: 30 }, (_, i) => {
    const d = new Date(); d.setDate(d.getDate() - (29 - i));
    const hours = (Number(stats.value.dailyHours) || 1.5) + Math.sin(i / 6) * 0.5 + (Math.random() - 0.5) * 0.3;
    return { date: d.toISOString().slice(0, 10), hours: Number(hours.toFixed(2)) };
  });
  const data = trendSeries.value && trendSeries.value.length ? trendSeries.value : fallback;
  const x = data.map(d => d.date);
  const y = data.map(d => Math.max(0.2, d.hours));
  const step = Math.max(0, Math.ceil(x.length / 8) - 1);
  trendChart.setOption({
    tooltip: { trigger: 'axis' },
    grid: { left: 40, right: 16, top: 24, bottom: 24 },
    xAxis: {
      type: 'category',
      data: x,
      axisLabel: {
        formatter: (v: string) => (v || '').slice(5),
        interval: step,
        hideOverlap: true,
        showMinLabel: true,
        showMaxLabel: true
      },
      axisTick: { alignWithLabel: true, interval: step }
    },
    yAxis: { type: 'value' },
    series: [{
      type: 'line', data: y, smooth: true,
      areaStyle: { color: 'rgba(59,124,255,0.12)' },
      lineStyle: { color: '#3B7CFF', width: 2 },
      itemStyle: { color: '#3B7CFF' }
    }]
  });
}

async function initSkillChart() {
  const el = document.getElementById('skillGraphChart');
  if (!el) return;
  skillChart = skillChart || echarts.init(el as HTMLDivElement);
}

async function initKnowledgeChart() {
  const el = document.getElementById('knowledgeGraphChart');
  if (!el) return;
  knowledgeChart = knowledgeChart || echarts.init(el as HTMLDivElement);
}

function toGraphData(nodes: { name: string; value: number }[], centerName: string) {
  const graphNodes = [{ name: centerName, value: 100, symbolSize: 36, itemStyle: { color: '#3B7CFF' }, label: { color: '#2B395B' } }];
  const links: any[] = [];
  nodes.forEach(n => {
    graphNodes.push({ name: n.name, value: n.value, symbolSize: Math.max(16, Math.floor(n.value / 2)), itemStyle: { color: '#38C793' }, label: { color: '#2B395B' } });
    links.push({ source: centerName, target: n.name, value: n.value });
  });
  return { graphNodes, links };
}

function formatLinks(edges: { source: string; target: string; weight: number }[]) {
  return edges.map(e => ({ ...e, lineStyle: { width: Math.max(1, e.weight) } }));
}

async function updateSkillChart() {
  await initSkillChart();
  if (!skillChart) return;
  const fallback = toGraphData(skillNodes.value.length ? skillNodes.value : [...coreSkills.value, ...appliedSkills.value], subject.value);
  const links = skillEdges.value.length ? formatLinks(skillEdges.value) : fallback.links;
  const graphNodes = fallback.graphNodes;
  skillChart.setOption({
    tooltip: {},
    series: [{
      type: 'graph',
      layout: 'force',
      roam: true,
      label: { show: true },
      force: { repulsion: 220, edgeLength: 100 },
      data: graphNodes,
      links,
    }]
  });
}

async function updateKnowledgeChart() {
  await initKnowledgeChart();
  if (!knowledgeChart) return;
  const fallback = toGraphData(knowledgeNodes.value.length ? knowledgeNodes.value : [...classicKnowledge.value, ...modernKnowledge.value], subject.value);
  const links = knowledgeEdges.value.length ? formatLinks(knowledgeEdges.value) : fallback.links;
  const graphNodes = fallback.graphNodes;
  knowledgeChart.setOption({
    tooltip: {},
    series: [{
      type: 'graph',
      layout: 'force',
      roam: true,
      label: { show: true },
      force: { repulsion: 220, edgeLength: 100 },
      data: graphNodes,
      links,
    }]
  });
}

onMounted(() => {
  fetchTrend();
  fetchSkillGraph();
  fetchKnowledgeGraph();
  nextTick(() => { updateTrendChart(); updateSkillChart(); updateKnowledgeChart(); });
});

watch(currentTab, () => {
  nextTick(() => {
    if (currentTab.value === 0) updateTrendChart();
    if (currentTab.value === 1) updateSkillChart();
    if (currentTab.value === 2) updateKnowledgeChart();
  });
});

async function fetchTrend() {
  const base = (dataBySubject[subject.value]?.stats?.dailyHours ?? 1.5) as number;
  const days = 30;
  const start = new Date(); start.setDate(start.getDate() - (days - 1));
  const list = Array.from({ length: days }, (_, i) => {
    const d = new Date(start); d.setDate(start.getDate() + i);
    const v = base + Math.sin(i / 6) * 0.5 + (Math.random() - 0.5) * 0.3;
    return { date: d.toISOString().slice(0, 10), hours: Number(Math.max(0.2, Number(v.toFixed(2)))) };
  });
  trendSeries.value = list;
  nextTick(updateTrendChart);
}

async function fetchSkillGraph() {
  const d = (dataBySubject[subject.value] || {}) as any;
  const base = [...(d.coreSkills || []), ...(d.appliedSkills || [])];
  const tags = ['基础', '应用', '拓展'];
  const nodes = base.flatMap((n: any) => {
    const children = tags.map(t => ({ name: `${n.name}-${t}`, value: Math.max(40, Math.min(95, n.value + Math.round((Math.random() - 0.5) * 20))) }));
    return [n, ...children];
  });
  const center = subject.value;
  const edges: any[] = [];
  base.forEach((n: any) => {
    edges.push({ source: center, target: n.name, weight: Math.max(1, Math.floor(n.value / 20)) });
    tags.forEach(t => { edges.push({ source: n.name, target: `${n.name}-${t}`, weight: 1 }); });
  });
  skillNodes.value = nodes;
  skillEdges.value = edges;
  nextTick(updateSkillChart);
}

async function fetchKnowledgeGraph() {
  const d = (dataBySubject[subject.value] || {}) as any;
  const base = [...(d.classicKnowledge || []), ...(d.modernKnowledge || [])];
  const tags = ['基础概念', '例题', '易错点'];
  const nodes = base.flatMap((n: any) => {
    const children = tags.map(t => ({ name: `${n.name}-${t}`, value: Math.max(40, Math.min(95, n.value + Math.round((Math.random() - 0.5) * 20))) }));
    return [n, ...children];
  });
  const center = subject.value;
  const edges: any[] = [];
  base.forEach((n: any) => {
    edges.push({ source: center, target: n.name, weight: Math.max(1, Math.floor(n.value / 20)) });
    tags.forEach(t => { edges.push({ source: n.name, target: `${n.name}-${t}`, weight: 1 }); });
  });
  knowledgeNodes.value = nodes;
  knowledgeEdges.value = edges;
  nextTick(updateKnowledgeChart);
}
</script>


<style lang="scss" scoped>
@import '@/styles/variables.scss';

.portrait-page {
  min-height: 100vh;
  background-color: $bg-color;
  display: flex;
  flex-direction: column;
}

.tab-bar {
  position: relative;
  display: flex;
  background-color: $card-bg;
  padding: 0 32rpx;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.05);
}

.tab-item {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  height: 88rpx;
}

.tab-text {
  font-size: $font-size-base;
  color: $text-secondary;
  font-weight: 500;
  transition: $transition-fast;
}

.tab-item.active .tab-text {
  color: $primary-color;
  font-weight: bold;
}

.tab-indicator {
  position: absolute;
  bottom: 0;
  left: 0;
  width: 25%;
  height: 6rpx;
  background: $gradient-primary;
  border-radius: 3rpx 3rpx 0 0;
  transition: left 0.3s ease;
}

.content-area {
  flex: 1;
  padding: 24rpx 32rpx;
  box-sizing: border-box;
}

.subject-tabs {
  display: flex;
  gap: 12rpx;
  margin-bottom: 16rpx;
}

.subject-tab {
  padding: 8rpx 16rpx;
  background: $bg-color;
  border-radius: 24rpx;
  font-size: $font-size-xs;
  color: $text-secondary;
}

.subject-tab.active {
  background: $card-bg;
  color: $primary-color;
  font-weight: bold;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.05);
}

.section {
  display: flex;
  flex-direction: column;
  gap: 24rpx;
}

.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.section-title {
  font-size: $font-size-lg;
  font-weight: bold;
  color: $text-primary;
}

.section-actions {
  display: flex;
  gap: 12rpx;
}

.action {
  padding: 8rpx 16rpx;
  background: $bg-color;
  border-radius: 24rpx;
  font-size: $font-size-xs;
  color: $primary-color;
}

.grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 24rpx;
}

.stat-block {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}

.block-title {
  font-size: $font-size-base;
  font-weight: 600;
  color: $text-primary;
  margin-bottom: 8rpx;
}

.stat-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.stat-label {
  font-size: $font-size-sm;
  color: $text-secondary;
}

.stat-value {
  font-size: $font-size-lg;
  font-weight: bold;
}

.stat-value.primary {
  color: $primary-color;
}

.stat-value.success {
  color: $success-color;
}

.stat-value.warning {
  color: $warning-color;
}

.habit-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 12rpx;
}

.habit-label {
  font-size: $font-size-sm;
  color: $text-secondary;
}

.habit-tag {
  padding: 8rpx 16rpx;
  background: $bg-color;
  border-radius: 24rpx;
  font-size: $font-size-xs;
  color: $text-primary;
}

.habit-badge {
  padding: 8rpx 16rpx;
  border-radius: 24rpx;
  font-size: $font-size-xs;
  font-weight: bold;
}

.habit-badge.good {
  background-color: rgba(82, 196, 26, 0.1);
  color: $success-color;
}

.habit-badge.warn {
  background-color: rgba(250, 173, 20, 0.1);
  color: $warning-color;
}

.chart-box {
  padding: 12rpx;
  background: #F7FAFF;
  border-radius: $border-radius;
}

.chart-canvas {
  width: 100%;
  height: 300rpx;
  display: block;
}

.summary-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 24rpx;
}

.summary {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8rpx;
}

.summary-num {
  font-size: $font-size-xl;
  font-weight: bold;
}

.summary-num.primary {
  color: $primary-color;
}

.summary-num.success {
  color: $success-color;
}

.summary-num.warning {
  color: $warning-color;
}

.summary-num.info {
  color: $info-color;
}

.summary-label {
  font-size: $font-size-sm;
  color: $text-secondary;
}

.sub-section {
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}

.sub-title {
  font-size: $font-size-base;
  font-weight: 600;
  color: $text-primary;
}

.bar {
  display: grid;
  grid-template-columns: 1fr auto auto;
  align-items: center;
  gap: 12rpx;
}

.bar-label {
  font-size: $font-size-sm;
  color: $text-secondary;
}

.bar-track {
  height: 12rpx;
  background-color: $divider-color;
  border-radius: 6rpx;
  overflow: hidden;
}

.bar-fill {
  height: 100%;
  background: $gradient-primary;
}

.bar-value {
  font-size: $font-size-xs;
  color: $text-primary;
}

.res-item {
  position: relative;
  display: flex;
  align-items: center;
  gap: 24rpx;
  padding: 12rpx 0 80rpx 0;
  min-height: 180rpx;
}

.res-icon {
  font-size: 44rpx;
}

.res-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 10rpx;
  padding-right: 180rpx;
  box-sizing: border-box;
}

.res-title {
  font-size: $font-size-base;
  color: $text-primary;
  font-weight: 600;
}

.res-desc {
  font-size: $font-size-sm;
  color: $text-secondary;
}

.res-tags {
  display: flex;
  gap: 12rpx;
  flex-wrap: wrap;
}

.res-tag {
  padding: 6rpx 12rpx;
  background: $bg-color;
  border-radius: 16rpx;
  font-size: $font-size-xs;
  color: $text-secondary;
}

.res-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 12rpx;
}

.res-actions {
  position: absolute;
  right: 24rpx;
  bottom: 2rpx;
  display: flex;
  gap: 12rpx;
  align-items: center;
}

.skill-tags {
  display: flex;
  gap: 8rpx;
  flex-wrap: wrap;
  margin-top: 6rpx;
}

.skill-tag {
  padding: 6rpx 10rpx;
  background: #F0F6FF;
  border-radius: 14rpx;
  font-size: $font-size-xs;
  color: $primary-color;
}

.section {
  gap: 28rpx;
}
</style>
