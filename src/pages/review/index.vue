<template>
  <view class="review-page">
    <Card>
      <text class="title">复盘中心</text>
      <text class="sub">查看试卷批改分析并生成随练组合</text>
    </Card>
    <scroll-view scroll-y class="content">
      <Card>
        <view class="review-section">
          <text class="review-title">📄 试卷批改·深度复盘</text>
          <view class="review-overview">
            <view class="review-score">{{ reviewScore }} 分</view>
            <view class="review-meta">
              <text>班级均分：{{ classAvg }} 分</text>
              <text>满分：{{ fullScore }} 分 · 正确率：{{ accuracyRate }}%</text>
            </view>
          </view>
        </view>
      </Card>

      <Card>
        <view class="section-header">
          <text class="section-title">最近习题</text>
        </view>
        <view class="exercise-list">
          <view v-for="ex in recentExercises" :key="ex.key"
            :class="['exercise-item', { active: selected && selected.key === ex.key }]" @tap="selectExercise(ex)">
            <view class="ex-top">
              <text class="ex-subject">{{ ex.subject }}</text>
              <text :class="['ex-status', ex.status]">{{ ex.statusText }}</text>
            </view>
            <text class="ex-stem">{{ ex.stem }}</text>
            <view class="ex-meta">
              <text>题型：{{ ex.typeText }}</text>
              <text v-if="ex.score">分值：{{ ex.score }}</text>
            </view>
          </view>
        </view>
      </Card>

      <Card v-if="selected">
        <view class="detail-section">
          <text class="detail-title">题目复盘</text>
          <view class="detail-meta">
            <text>{{ selected.subject }} · {{ selected.typeText }} · 分值 {{ selected.score }}</text>
          </view>

          <view class="detail-knowledge">
            <text class="sub-title">知识点掌握情况</text>
            <view v-for="k in detailKnowledge" :key="k.name" class="k-item">
              <text class="k-name">{{ k.name }}</text>
              <view class="k-bar">
                <view class="k-fill" :style="{ width: Math.max(0, Math.min(100, k.value)) + '%' }"></view>
              </view>
              <text class="k-val">{{ k.value }}%</text>
            </view>
          </view>

          <view class="detail-advice">
            <text class="sub-title">学习建议</text>
            <view class="advice-list">
              <view class="advice-item" v-for="a in studyAdvice" :key="a.id || a.title">
                <text class="advice-icon">{{ a.icon || '📘' }}</text>
                <view class="advice-info">
                  <text class="advice-title">{{ a.title }}</text>
                  <text class="advice-desc">{{ a.desc }} · 匹配度 {{ a.match }}%</text>
                </view>
                <Button text="去学习" type="secondary" size="small" @click="goResource(a)" />
              </view>
            </view>
          </view>

          <view class="detail-error" v-if="errorAnalysis">
            <text class="sub-title">错题分析</text>
            <view class="error-box">
              <text class="err-line">你的答案：{{ errorAnalysis.studentAnswer || '未作答' }}</text>
              <text class="err-line">正确答案：{{ errorAnalysis.correctAnswer }}</text>
              <text class="err-line">典型误区：{{ errorAnalysis.misconception }}</text>
              <text class="err-line">改进建议：{{ errorAnalysis.fix }}</text>
            </view>
          </view>

          <view class="review-actions">
            <Button class="center-primary" text="生成随练组合" type="primary" size="small" @click="goCombo" />
          </view>
        </view>
      </Card>



    </scroll-view>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { onLoad } from '@dcloudio/uni-app';
import Card from '@/components/common/Card.vue';
import Button from '@/components/common/Button.vue';
import portraitJson from '@/mock/portrait.json';
import homeworkJson from '@/mock/homework.json';

const reviewScore = ref(86);
const classAvg = ref(83);
const fullScore = ref(100);
const accuracyRate = ref(88);
const weakKnowledge = ref<any[]>([]);

function computeWeakKnowledgeFor(subject: string) {
  const pd: any = (portraitJson as any)[subject];
  if (!pd) return [];
  const list = [...(pd.classicKnowledge || []), ...(pd.modernKnowledge || [])]
    .filter((x: any) => typeof x.value === 'number')
    .sort((a: any, b: any) => a.value - b.value)
    .slice(0, 5);
  return list;
}

function refreshReview() {
  try {
    accuracyRate.value = Math.max(60, Math.min(99, Math.round(88)));
    reviewScore.value = Math.max(60, Math.min(99, Math.round((accuracyRate.value + 85) / 2)));
    classAvg.value = Math.max(60, Math.min(99, Math.round(reviewScore.value - 3)));
    weakKnowledge.value = computeWeakKnowledgeFor('数学');
  } catch { }
}

function goReview() {
  uni.switchTab({ url: '/pages/discover/index' });
  setTimeout(() => uni.$emit('switchTab', { tab: 'resource' }), 150);
}

function goCombo() {
  const s = '数学';
  uni.navigateTo({ url: `/pages/plan/index?subject=${encodeURIComponent(s)}` });
}

onLoad(() => {
  refreshReview();
  buildRecentExercises();
});

// 最近习题与详情
const recentExercises = ref<any[]>([]);
const selected = ref<any | null>(null);
const detailKnowledge = ref<any[]>([]);
const studyAdvice = ref<any[]>([]);
const errorAnalysis = ref<any | null>(null);

function detectSubjectFromCourse(name: string): string {
  if (!name) return '综合';
  if (name.includes('数学')) return '数学';
  if (name.includes('英语')) return '英语';
  if (name.includes('语文')) return '语文';
  if (name.includes('科学')) return '科学';
  return '综合';
}

function buildRecentExercises() {
  const list = (homeworkJson as any).homework || [];
  const flat: any[] = [];
  list.forEach((h: any) => {
    const subject = detectSubjectFromCourse(h.courseName || '');
    (h.questions || []).forEach((q: any) => {
      const key = `${h.id}-${q.id}`;
      const status = h.status || 'pending';
      flat.push({
        key,
        subject,
        stem: q.stem,
        type: q.type,
        typeText: q.type === 'choice' ? '选择题' : q.type === 'fill-blank' ? '填空题' : q.type === 'essay' ? '应用题' : '题目',
        score: q.score || 0,
        status,
        statusText: status === 'graded' ? '已批改' : '待完成',
        correctAnswer: q.answer,
        h,
        q
      });
    });
  });
  recentExercises.value = flat.slice(0, 5);
}

function masteryFor(subject: string, name: string): number {
  const pd: any = (portraitJson as any)[subject];
  if (!pd) return 70;
  const all = [...(pd.coreSkills || []), ...(pd.classicKnowledge || []), ...(pd.modernKnowledge || [])];
  const found = all.find((x: any) => String(x.name).includes(name));
  return typeof found?.value === 'number' ? found.value : (pd.knowledge?.overall ?? 70);
}

function mapKnowledge(subject: string, q: any): any[] {
  if (subject === '数学') {
    if (q.type === 'choice' && /一元一次方程|方程/.test(q.stem)) return [{ name: '一元一次方程', value: masteryFor(subject, '一元一次方程') }, { name: '解方程方法', value: masteryFor(subject, '解方程方法') }];
    if (q.type === 'essay' && /应用|方程/.test(q.stem)) return [{ name: '应用题建模', value: masteryFor(subject, '应用题建模') }, { name: '题型归纳', value: masteryFor(subject, '题型归纳') }];
    if (/几何|角度/.test(q.stem)) return [{ name: '图形与角度', value: masteryFor(subject, '图形与角度') }];
  }
  if (subject === '语文') {
    if (/古诗|默写/.test(q.stem)) return [{ name: '古诗词背诵', value: masteryFor(subject, '古诗词背诵') }, { name: '默写能力', value: masteryFor(subject, '默写能力') }];
  }
  if (subject === '英语') {
    if (/语法|be|代词|is your name/.test(q.stem)) return [{ name: '基础语法', value: masteryFor(subject, '基础语法') }];
  }
  return [{ name: '综合掌握', value: masteryFor(subject, 'overall') }];
}

function adviceFor(subject: string, knowledgeList: any[]): any[] {
  const pd: any = (portraitJson as any)[subject];
  const resources = (pd?.resources || []) as any[];
  const names = knowledgeList.map(k => k.name);
  const scored = resources.map(r => {
    const hit = (r.skills || []).filter((s: string) => names.some(n => s.includes(n) || n.includes(s))).length;
    const bonus = hit > 0 ? 8 * hit : 0;
    return { ...r, match: Math.min(100, (r.match || 80) + bonus) };
  }).sort((a, b) => (b.match || 0) - (a.match || 0));
  return scored.slice(0, 3);
}

function analyzeError(ex: any): any | null {
  const h = ex.h;
  const q = ex.q;
  if (h.status !== 'graded') return null;
  const gd = (h.gradedDetails || {})[q.id];
  if (!gd) return null;
  const correct = Array.isArray(q.answer) ? q.answer.join('/') : q.answer;
  const stu = gd.studentAnswer || (h.studentAnswers || {})[q.id];
  let misconception = '理解偏差';
  let fix = '回顾概念与例题，按步骤作答';
  if (ex.subject === '数学' && /一元一次方程/.test(q.stem)) {
    misconception = '把一元一次与二元或二次方程混淆，或遗漏移项/合并同类项';
    fix = '复习一元一次方程定义与求解流程，先移项再合并同类项，检查未知数个数与次数';
  } else if (ex.subject === '英语' && /is your name/.test(q.stem)) {
    misconception = '疑问词选择错误，“How/Where”不能引出姓名';
    fix = '复习疑问词用法：询问姓名用“What”，地点用“Where”，方式用“How”';
  }
  return { studentAnswer: stu, correctAnswer: correct, misconception, fix };
}

function selectExercise(ex: any) {
  selected.value = ex;
  detailKnowledge.value = mapKnowledge(ex.subject, ex.q);
  studyAdvice.value = adviceFor(ex.subject, detailKnowledge.value);
  errorAnalysis.value = analyzeError(ex);
}

function goResource(r: any) {
  uni.navigateTo({ url: '/pages/discover/resource-detail' });
}
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.review-page {
  min-height: 100vh;
  background-color: $bg-color;
  padding: 24rpx 32rpx;
  box-sizing: border-box;
}

.title {
  font-size: $font-size-lg;
  font-weight: bold;
  color: $text-primary;
}

.sub {
  display: block;
  margin-top: 8rpx;
  font-size: $font-size-sm;
  color: $text-secondary;
}

.content {
  padding-top: 8rpx;
}

.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 8rpx;
  padding: 0 4rpx;
}

.section-title {
  font-size: $font-size-base;
  color: $text-primary;
  font-weight: 600;
}

.exercise-list {
  display: flex;
  flex-direction: column;
  gap: 8rpx;
}

.exercise-item {
  background: $bg-color;
  border-radius: $border-radius;
  padding: 16rpx;
  box-shadow: $shadow-card;
}

.exercise-item.active {
  border: 2rpx solid #2B46FE;
}

.ex-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 6rpx;
}

.ex-subject {
  font-size: $font-size-xs;
  color: $text-secondary;
}

.ex-status {
  font-size: $font-size-xs;
  padding: 4rpx 8rpx;
  border-radius: 999rpx;
  background: $bg-color;
}

.ex-status.graded {
  color: #12B76A;
  background: rgba(18, 183, 106, 0.12);
}

.ex-status.pending {
  color: #6C7A91;
  background: rgba(108, 122, 145, 0.12);
}

.ex-stem {
  font-size: $font-size-sm;
  color: $text-primary;
  font-weight: 600;
  line-height: 1.5;
}

.ex-meta {
  display: flex;
  gap: 12rpx;
  font-size: $font-size-xs;
  color: $text-secondary;
  margin-top: 6rpx;
}

.detail-section {
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}

.detail-title {
  font-size: $font-size-lg;
  font-weight: bold;
  color: $text-primary;
}

.detail-meta {
  font-size: $font-size-xs;
  color: $text-secondary;
}

.detail-knowledge {
  display: flex;
  flex-direction: column;
  gap: 8rpx;
}

.sub-title {
  font-size: $font-size-sm;
  color: $text-primary;
  font-weight: 600;
}

.k-item {
  display: grid;
  grid-template-columns: auto 1fr auto;
  align-items: center;
  gap: 12rpx;
}

.k-name {
  font-size: $font-size-xs;
  color: $text-secondary;
}

.k-bar {
  height: 12rpx;
  background: $divider-color;
  border-radius: 6rpx;
  overflow: hidden;
}

.k-fill {
  height: 100%;
  background: $gradient-primary;
}

.k-val {
  font-size: $font-size-xs;
  color: $text-secondary;
}

.advice-list {
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}

.advice-item {
  display: flex;
  align-items: center;
  gap: 12rpx;
  background: $bg-color;
  border-radius: $border-radius;
  padding: 12rpx;
}

.advice-item .custom-button {
  flex-shrink: 0;
  min-width: 120rpx;
}

.advice-item .button-small {
  padding: 0 36rpx;
}

.advice-icon {
  font-size: 36rpx;
}

.advice-title {
  font-size: $font-size-sm;
  color: $text-primary;
  font-weight: 600;
}

.advice-desc {
  font-size: $font-size-xs;
  color: $text-secondary;
}

.error-box {
  display: flex;
  flex-direction: column;
  gap: 6rpx;
  background: $bg-color;
  border-radius: $border-radius;
  padding: 12rpx;
}

.err-line {
  font-size: $font-size-xs;
  color: $text-secondary;
}

.review-section {
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}

.review-title {
  font-size: $font-size-lg;
  font-weight: bold;
  color: $text-primary;
}

.review-overview {
  display: flex;
  align-items: center;
  gap: 16rpx;
}

.review-score {
  font-size: 40rpx;
  font-weight: 700;
  color: $primary-color;
}

.review-meta {
  display: flex;
  flex-direction: column;
  gap: 4rpx;
  font-size: $font-size-xs;
  color: $text-secondary;
}

.review-knowledge {
  display: flex;
  flex-direction: column;
  gap: 8rpx;
  margin-top: 4rpx;
}

.sub-title {
  font-size: $font-size-sm;
  color: $text-primary;
  font-weight: 600;
}

.k-item {
  display: grid;
  grid-template-columns: auto 1fr auto;
  align-items: center;
  gap: 12rpx;
}

.k-name {
  font-size: $font-size-xs;
  color: $text-secondary;
}

.k-bar {
  height: 12rpx;
  background: $divider-color;
  border-radius: 6rpx;
  overflow: hidden;
}

.k-fill {
  height: 100%;
  background: $gradient-primary;
}

.k-val {
  font-size: $font-size-xs;
  color: $text-secondary;
}

.review-actions {
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}

.center-primary {
  align-self: center;
}

/* 汇总样式已移除 */
</style>
