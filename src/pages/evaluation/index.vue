<template>
  <view class="evaluation-page">
    <scroll-view scroll-y class="content">
      <Card>
        <view class="period-tabs">
          <view v-for="p in periods" :key="p" :class="['period', { active: p === period }]" @tap="period = p">{{ p }}</view>
        </view>
      </Card>

      <Card>
        <view class="overview">
          <!-- uni-app canvas -->
          <canvas canvas-id="radarCanvas" id="radarCanvas" class="radar" v-if="canvasSupported"></canvas>
          <view v-else class="radar-fallback">
            <view class="fallback-circle">
              <view class="fallback-score">{{ totalScore }}</view>
              <view class="fallback-label">综合得分</view>
            </view>
          </view>
          <view class="labels">
            <text>知识掌握</text>
            <text>作业质量</text>
            <text>学习态度</text>
            <text>课堂参与</text>
            <text>自主学习</text>
          </view>
          <text class="score">综合得分：{{ totalScore }}/100 · 超越 {{ surpass }}%</text>
          <text class="summary">评价记录：{{ evalError ? ('错误：' + evalError) : (evalCount===null ? '加载中...' : (evalCount + ' 条')) }}</text>
        </view>
      </Card>

      <Card>
        <view class="metric">
          <text class="metric-title">📚 知识掌握度</text>
          <view class="metric-bar"><view class="fill" style="width: 88%"></view></view>
          <text class="metric-sub">高数(92%) 英语(85%) 物理(87%)</text>
        </view>
      </Card>

      <Card>
        <view class="metric">
          <text class="metric-title">✅ 作业完成质量</text>
          <view class="metric-bar"><view class="fill" style="width: 90%"></view></view>
          <text class="metric-sub">按时率(95%) 正确率(88%) · 建议：加强计算题练习</text>
        </view>
      </Card>

      <Card>
        <view class="metric">
          <text class="metric-title">💬 课堂参与度</text>
          <view class="metric-bar"><view class="fill" style="width: 75%"></view></view>
          <text class="metric-sub">讨论次数(8) 提问次数(3) · 建议：多参与课堂讨论</text>
        </view>
      </Card>

      <Card>
        <view class="metric">
          <text class="metric-title">⏰ 学习时长统计</text>
          <view class="metric-bar"><view class="fill" style="width: 62%"></view></view>
          <text class="metric-sub">本周总计：12.5小时 · 日均：2.5小时</text>
        </view>
      </Card>

      <Card>
        <view class="ai-section">
          <text class="ai-title">🤖 AI学习分析</text>
          <text class="ai-text">• 你在数学学科表现优异，保持！\n• 英语学习时长略少，建议增加...\n• 课堂参与度有提升空间，可以...</text>
          <Button text="生成学习计划建议" type="primary" size="large" @click="genPlan" />
        </view>
      </Card>
    </scroll-view>
  </view>
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from 'vue';
import Card from '@/components/common/Card.vue';
import Button from '@/components/common/Button.vue';
import { useAppStore } from '@/stores/app';
import portraitJson from '@/mock/portrait.json';
import homeworkJson from '@/mock/homework.json';
import achievementsJson from '@/mock/achievements.json';
import { storage, StorageKeys } from '@/utils/storage';
import { listEvaluations } from '@/services/evaluation';

const appStore = useAppStore();
const periods = ['本周', '本月', '本学期'];
const period = ref('本周');
const canvasSupported = ref(true);
const evalCount = ref<number | null>(null);
const evalError = ref<string | null>(null);

function levelToScore(lvl: string) { return lvl==='good' ? 85 : 70; }
function clamp(n:number,min:number,max:number){ return Math.max(min, Math.min(max, n)); }

// 数据验证工具函数
function validateRadarData(data: number[]): boolean {
  if (!Array.isArray(data) || data.length !== 5) {
    console.warn('雷达图数据格式错误：需要5个数值的数组');
    return false;
  }
  
  for (let i = 0; i < data.length; i++) {
    if (typeof data[i] !== 'number' || isNaN(data[i]) || data[i] < 0 || data[i] > 100) {
      console.warn(`雷达图数据无效：第${i + 1}个值为${data[i]}`);
      return false;
    }
  }
  
  return true;
}

// 计算综合得分
function calculateTotalScore(data: number[]): number {
  if (!validateRadarData(data)) return 75;
  return Math.round(data.reduce((sum, score) => sum + score, 0) / data.length);
}
function computeRadar(periodSel: string): number[] {
  try {
    const portraits:any = portraitJson as any;
    const subs = Object.keys(portraits);
    
    // 数据验证函数
    const validateNumber = (value: any, defaultValue: number): number => {
      const num = Number(value);
      return isNaN(num) || num < 0 || num > 100 ? defaultValue : Math.round(num);
    };
    
    // 1 知识掌握：各学科 knowledge.overall 平均
    const knowledgeVals = subs.map(s => validateNumber(portraits[s]?.knowledge?.overall, 75));
    const knowledgeAvg = knowledgeVals.length > 0 ? 
      Math.round(knowledgeVals.reduce((a, b) => a + b, 0) / knowledgeVals.length) : 75;
    
    // 2 作业质量：已批改作业的得分率平均
    const graded = (homeworkJson.homework || []).filter((h: any) => h?.status === 'graded');
    const hwScore = graded.length > 0 ? 
      Math.round(graded.reduce((a: number, h: any) => {
        const score = validateNumber(h?.score, 0);
        const total = validateNumber(h?.totalScore, 100);
        return a + (score / total) * 100;
      }, 0) / graded.length) : 80;
    
    // 3 学习态度：习惯综合（连续性+复习）
    const habitVals = subs.map(s => {
      const h = portraits[s]?.habits || {};
      const c = levelToScore(h?.continuity?.level || 'good');
      const r = levelToScore(h?.review?.level || 'good');
      return (c + r) / 2;
    });
    const habitAvg = habitVals.length > 0 ? 
      Math.round(habitVals.reduce((a, b) => a + b, 0) / habitVals.length) : 75;
    
    // 4 课堂参与：讨论热度平均（或回复/点赞折算）
    const ds = (achievementsJson.discussions || []);
    const participate = ds.length > 0 ? 
      Math.round(ds.reduce((a: number, d: any) => {
        const heat = validateNumber(d?.heat, 0);
        const replies = validateNumber(d?.replies, 0);
        const likes = validateNumber(d?.likes, 0);
        return a + (heat || (replies * 2 + likes));
      }, 0) / ds.length) : 70;
    const participateClamped = clamp(participate, 50, 95);
    
    // 5 自主学习：学习时长统计（以600分钟为满分）
    const stats = storage.get(StorageKeys.STUDY_STATS) as any;
    const minutes = validateNumber(stats?.todayStudyMinutes, 60);
    const studyScore = clamp(Math.round((minutes / 600) * 100), 40, 100);
    
    const result = [knowledgeAvg, hwScore, habitAvg, participateClamped, studyScore];
    
    // 最终数据验证
    return result.map(score => validateNumber(score, 75));
  } catch (error) {
    console.error('雷达图数据计算错误:', error);
    return [75, 75, 75, 75, 75]; // 默认安全数据
  }
}
const labels = ['知识掌握','作业质量','学习态度','课堂参与','自主学习'];
const totalScore = ref(85);
const surpass = ref(78);

function drawRadar() {
  try {
    // 使用uni-app的canvas API
    const ctx = uni.createCanvasContext('radarCanvas');
    if (!ctx) {
      console.warn('Canvas context not available');
      return;
    }
    
    // 获取canvas实际尺寸 - 移除this上下文避免TypeScript错误
    const query = uni.createSelectorQuery();
    query.select('#radarCanvas').boundingClientRect((rect: any) => {
      if (!rect || !rect.width || !rect.height) {
        console.warn('Canvas dimensions not available');
        return;
      }
      
      const canvasWidth = rect.width;
      const canvasHeight = rect.height;
      const containerSize = Math.min(canvasWidth, canvasHeight);
      const centerX = containerSize / 2;
      const centerY = containerSize / 2;
      const radius = Math.min(centerX, centerY) * 0.8; // 80% of half size for padding
      const steps = 5;
      const angles = labels.length;
      
      // 清除画布
      ctx.clearRect(0, 0, containerSize, containerSize);
      
      // 保存当前状态
      ctx.save();
      
      // 移动到中心点
      ctx.translate(centerX, centerY);
      
      // 绘制网格圆圈
      ctx.strokeStyle = '#E6E8F0';
      ctx.lineWidth = 1;
      for (let s = 1; s <= steps; s++) {
        const r = radius * (s / steps);
        ctx.beginPath();
        ctx.arc(0, 0, r, 0, 2 * Math.PI);
        ctx.stroke();
      }
      
      // 绘制轴线
      ctx.strokeStyle = '#D3D7E3';
      ctx.lineWidth = 1;
      for (let i = 0; i < angles; i++) {
        const angle = (Math.PI * 2 / angles) * i - Math.PI / 2;
        ctx.beginPath();
        ctx.moveTo(0, 0);
        ctx.lineTo(radius * Math.cos(angle), radius * Math.sin(angle));
        ctx.stroke();
      }
      
      // 获取并验证数据
      const vals = computeRadar(period.value);
      
      // 验证数据完整性
      if (!validateRadarData(vals)) {
        console.warn('雷达图数据验证失败，使用默认数据');
        return;
      }
      
      // 更新综合得分显示
      const total = calculateTotalScore(vals);
      totalScore.value = total;
      
      const validVals = vals;
      
      // 绘制数据多边形
      ctx.beginPath();
      for (let i = 0; i < angles; i++) {
        const v = validVals[i] / 100; // 标准化到0-1
        const angle = (Math.PI * 2 / angles) * i - Math.PI / 2;
        const x = radius * v * Math.cos(angle);
        const y = radius * v * Math.sin(angle);
        if (i === 0) ctx.moveTo(x, y); else ctx.lineTo(x, y);
      }
      ctx.closePath();
      
      // 填充渐变
      const gradient = ctx.createCircularGradient(0, 0, radius);
      gradient.addColorStop(0, 'rgba(43, 70, 254, 0.4)');
      gradient.addColorStop(1, 'rgba(123, 97, 255, 0.2)');
      ctx.fillStyle = gradient as any;
      ctx.fill();
      
      // 描边
      ctx.lineWidth = 3;
      ctx.strokeStyle = '#2B46FE';
      ctx.stroke();
      
      // 绘制数据点
      for (let i = 0; i < angles; i++) {
        const v = validVals[i] / 100;
        const angle = (Math.PI * 2 / angles) * i - Math.PI / 2;
        const x = radius * v * Math.cos(angle);
        const y = radius * v * Math.sin(angle);
        
        // 外圈
        ctx.beginPath();
        ctx.arc(x, y, 6, 0, 2 * Math.PI);
        ctx.fillStyle = '#2B46FE';
        ctx.fill();
        
        // 内圈
        ctx.beginPath();
        ctx.arc(x, y, 3, 0, 2 * Math.PI);
        ctx.fillStyle = '#FFFFFF';
        ctx.fill();
      }
      
      // 恢复状态
      ctx.restore();
      
      // 绘制到canvas
      ctx.draw();
      
      console.log('雷达图绘制完成:', validVals);
    }).exec();
  } catch (error) {
    console.error('雷达图绘制错误:', error);
  }
}

onMounted(() => {
  // 延迟执行，确保canvas已经渲染完成
  setTimeout(() => {
    try {
      drawRadar();
    } catch (error) {
      console.error('雷达图初始化失败:', error);
      // 如果绘制失败，显示回退界面
      canvasSupported.value = false;
    }
  }, 500); // 增加延迟确保DOM完全加载
  setTimeout(async () => {
    try {
      const rows = await listEvaluations({ limit: 5, scenario: 'ok' });
      evalCount.value = Array.isArray(rows) ? rows.length : 0;
    } catch (e: any) {
      evalError.value = String(e?.message || '接口错误');
    }
  }, 300);
});

watch(period, () => {
  // 延迟执行，确保DOM更新完成
  setTimeout(() => {
    try {
      drawRadar();
    } catch (error) {
      console.error('雷达图更新失败:', error);
    }
  }, 200);
});

const genPlan = () => {
  appStore.showToast('生成学习计划功能开发中', 'none');
};
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.content { padding: 24rpx 32rpx 24rpx 32rpx; box-sizing: border-box; width: 100%; }

.period-tabs { display: flex; gap: 16rpx; }
.period { padding: 8rpx 16rpx; background: $bg-color; border-radius: 24rpx; font-size: $font-size-sm; color: $text-secondary; }
.period.active { background: $card-bg; color: $primary-color; font-weight: bold; box-shadow: 0 4rpx 12rpx rgba(0,0,0,0.05); }

.overview { display: flex; flex-direction: column; gap: 12rpx; align-items: center; padding: 20rpx 0; }
.radar { 
  width: 320rpx; 
  height: 320rpx; 
  background: #FFFFFF; 
  box-shadow: 0 4rpx 12rpx rgba(0,0,0,0.05); 
  border-radius: 12rpx; 
  border: 1rpx solid #f0f0f0;
}
.radar-fallback { 
  width: 320rpx; 
  height: 320rpx; 
  display: flex; 
  align-items: center; 
  justify-content: center; 
  margin: 10rpx 0; 
  background: #FFFFFF; 
  box-shadow: 0 4rpx 12rpx rgba(0,0,0,0.05); 
  border-radius: 12rpx; 
}
.fallback-circle { width: 200rpx; height: 200rpx; border-radius: 50%; background: linear-gradient(135deg, #2B46FE, #7B61FF); display: flex; flex-direction: column; align-items: center; justify-content: center; color: white; }
.fallback-score { font-size: 48rpx; font-weight: bold; }
.fallback-label { font-size: 24rpx; opacity: 0.9; }
.labels { display: grid; grid-template-columns: repeat(3, auto); gap: 8rpx 16rpx; color: $text-secondary; font-size: $font-size-xs; }
.score { margin-top: 8rpx; font-size: $font-size-sm; color: $text-primary; }
.summary { margin-top: 8rpx; font-size: $font-size-xs; color: $text-secondary; }

.metric { display: flex; flex-direction: column; gap: 8rpx; }
.metric-title { font-size: $font-size-base; color: $text-primary; font-weight: 600; }
.metric-bar { height: 12rpx; background: $divider-color; border-radius: 6rpx; overflow: hidden; }
.fill { height: 100%; background: $gradient-primary; }
.metric-sub { font-size: $font-size-xs; color: $text-secondary; }

.ai-section { display: flex; flex-direction: column; gap: 12rpx; }
.ai-title { font-size: $font-size-lg; font-weight: bold; color: $text-primary; }
.ai-text { white-space: pre-line; font-size: $font-size-sm; color: $text-secondary; line-height: 1.6; }
</style>
