<template>
  <view class="homework-detail-page">
    <Loading v-if="loading" text="正在加载作业..." />
    <view v-else>
      <Card>
        <view class="header">
          <text class="title">{{ hw.title }}</text>
          <view :class="['status', hw.status]">{{ statusText }}</view>
        </view>
        <text class="sub">课程：{{ hw.courseName }} · 截止：{{ hw.deadline }}</text>
        <text class="desc">题型：{{ hw.questionTypes }}</text>
      </Card>

      <Card v-if="hw.status === 'graded'">
        <view class="summary">
          <text class="summary-title">批改结果</text>
          <text class="summary-row">得分：{{ gradedScore }} / {{ totalScore }}</text>
          <text v-if="hw.teacherComment" class="summary-row">评语：{{ hw.teacherComment }}</text>
        </view>
      </Card>

      <Card>
        <view class="section">
          <text class="section-title">作业内容</text>
          <view v-for="(q, i) in hw.questions" :key="q.id" class="question">
          <text class="q-title">{{ i + 1 }}. {{ q.stem }} ({{ q.score }}分)</text>
          
          <!-- 选择题 -->
          <block v-if="q.type === 'choice'">
            <view class="choice-options">
              <view 
                v-for="opt in q.options" 
                :key="opt.label" 
                :class="['option', { 
                  'selected': (hw.studentAnswers || {})[q.id] === opt.label,
                  'correct': hw.status === 'graded' && q.type === 'choice' && opt.label === q.answer,
                  'wrong': hw.status === 'graded' && q.type === 'choice' && (hw.studentAnswers || {})[q.id] === opt.label && opt.label !== q.answer,
                  'disabled': !editable
                }]" 
                @click="editable && selectAnswer(q.id, opt.label)">
                <text class="option-label">{{ opt.label }}</text>
                <text>{{ opt.text }}</text>
              </view>
            </view>
          </block>

          <!-- 填空题 -->
          <block v-if="q.type === 'fill-blank'">
            <input 
              class="q-input" 
              :value="(hw.studentAnswers || {})[q.id]" 
              :disabled="!editable"
              @input="onInput(q.id, $event)" 
              placeholder="在此填写答案" />
          </block>

          <!-- 问答题 -->
          <block v-if="q.type === 'essay'">
            <textarea 
              class="q-textarea" 
              :value="(hw.studentAnswers || {})[q.id]" 
              :disabled="!editable"
              @input="onInput(q.id, $event)" 
              placeholder="在此填写答案" 
              auto-height />
          </block>

          <view v-if="hw.status === 'graded'" class="q-review">
            <text class="review-row">你的答案：{{ formatStudentAnswer(q) }}</text>
            <text class="review-row">正确答案：{{ formatCorrectAnswer(q) }}</text>
            <text v-if="q.explanation" class="review-row">解析：{{ q.explanation }}</text>
          </view>
        </view>
      </view>
    </Card>

      <Card v-if="hw.status === 'pending'">
        <view class="actions">
          <Button text="提交作业" type="primary" size="large" @click="submitHomework" />
        </view>
      </Card>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import { onLoad } from '@dcloudio/uni-app';
import Card from '@/components/common/Card.vue';
import Button from '@/components/common/Button.vue';
import Loading from '@/components/common/Loading.vue';
import { useAppStore } from '@/stores/app';
import { useUserStore } from '@/stores/user';
import homeworkJson from '@/mock/homework.json';
import type { Homework, AnyQuestion, ChoiceQuestion } from '@/types/course';

const appStore = useAppStore();
const userStore = useUserStore();

const loading = ref(true);
const hw = ref<Homework>({} as Homework);
const editable = computed(() => hw.value.status === 'pending');

const statusText = computed(() => {
  switch (hw.value.status) {
    case 'pending': return '待提交';
    case 'submitted': return '已提交';
    case 'graded': return '已批改';
    default: return '';
  }
});

function loadHomework(id: string) {
  loading.value = true;
  const list = (homeworkJson as any).homework || [];
  const data = list.find((x: any) => x.id === id);
  if (!data) {
    loading.value = false;
    appStore.showToast('作业不存在', 'none');
    return;
  }
  hw.value = {
    ...data,
    studentAnswers: data.studentAnswers || {},
  };
  loading.value = false;
}

function selectAnswer(questionId: string, answer: string) {
  if (hw.value.studentAnswers) {
    hw.value.studentAnswers[questionId] = answer;
  }
}

function recordAnswer(questionId: string, answer: string) {
  if (hw.value.studentAnswers) {
    hw.value.studentAnswers[questionId] = answer;
  }
}

onLoad((options: any) => {
  const id = options?.id || '';
  loadHomework(id);
});

const submitHomework = async () => {
  const ok = await appStore.showConfirm('确认提交作业吗？');
  if (!ok) return;

  let wrong = 0;
  let score = 0;
  const questions = hw.value.questions || [];
  const answers = hw.value.studentAnswers || {};

  for (const q of questions) {
    const studentAnswer = answers[q.id];
    if (!studentAnswer) {
      wrong++;
      continue;
    }
    if (q.type === 'choice') {
      if (studentAnswer.toLowerCase() === (q as ChoiceQuestion).answer.toLowerCase()) {
        score += q.score;
      } else {
        wrong++;
      }
    }
    // 简单处理填空和问答，实际应由教师批改
    else if (q.type === 'fill-blank' || q.type === 'essay') {
      score += q.score; // 模拟自动得分
    }
  }

  if (wrong > 0) {
    appStore.recordWrongAnswer(wrong);
    appStore.showToast(`有${wrong}题错误或未作答，请检查`, 'none');
  } else {
    appStore.resetWrongAnswer();
    hw.value.status = 'submitted';
    appStore.showToast('已提交作业，等待教师批改', 'success');
    userStore.addPoints(30);
    appStore.triggerEncouragement('celebration');
  }
};

const totalScore = computed(() => {
  const qs = hw.value.questions || [];
  return qs.reduce((s, q) => s + q.score, 0);
});

const gradedScore = computed(() => {
  const qs = hw.value.questions || [];
  const details = hw.value.gradedDetails || {};
  let s = 0;
  for (const q of qs) {
    if (q.type === 'choice') {
      const d = (details as any)[q.id];
      if (d && d.isCorrect) s += q.score;
    } else {
      s += q.score;
    }
  }
  return s;
});

function formatStudentAnswer(q: AnyQuestion) {
  const ans = hw.value.studentAnswers ? hw.value.studentAnswers[q.id] : undefined;
  if (ans === undefined || ans === null || ans === '') return '未作答';
  if (q.type === 'fill-blank') {
    return Array.isArray(ans) ? ans.join(' / ') : String(ans);
  }
  return String(ans);
}

function formatCorrectAnswer(q: AnyQuestion) {
  if (q.type === 'choice') return q.answer;
  if (q.type === 'fill-blank') return (q.answer || []).join(' / ');
  if (q.type === 'essay') return q.answer;
  return '';
}

function onInput(questionId: string, e: any) {
  const val = e && e.detail ? e.detail.value : '';
  recordAnswer(questionId, val);
}
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.homework-detail-page { padding: 24rpx 32rpx; }

.header { display: flex; align-items: center; justify-content: space-between; }
.title { font-size: $font-size-xl; font-weight: bold; color: $text-primary; }
.status { padding: 8rpx 16rpx; border-radius: 24rpx; font-size: $font-size-xs; font-weight: bold; }
.status.pending { background-color: rgba(250, 173, 20, 0.1); color: $warning-color; }
.status.submitted { background-color: rgba(24, 144, 255, 0.1); color: $info-color; }
.status.graded { background-color: rgba(82, 196, 26, 0.1); color: $success-color; }
.sub { display: block; margin-top: 8rpx; font-size: $font-size-sm; color: $text-secondary; }
.desc { display: block; margin-top: 8rpx; font-size: $font-size-sm; color: $text-secondary; }

.summary { display: flex; flex-direction: column; gap: 12rpx; }
.summary-title { font-size: $font-size-lg; font-weight: bold; color: $text-primary; }
.summary-row { font-size: $font-size-base; color: $text-secondary; }

.section-title { font-size: $font-size-lg; font-weight: bold; color: $text-primary; margin-bottom: 24rpx; }
.question { margin-bottom: 32rpx; }
.q-title { display: block; font-size: $font-size-base; color: $text-primary; margin-bottom: 16rpx; }
.q-input, .q-textarea { 
  background-color: $bg-color; 
  border-radius: $border-radius; 
  padding: 20rpx; 
  font-size: $font-size-base; 
  width: 100%;
  box-sizing: border-box;
}

.choice-options { display: flex; flex-direction: column; gap: 16rpx; }
.option {
  display: flex;
  align-items: center;
  padding: 20rpx;
  border-radius: $border-radius;
  background-color: $bg-color;
  border: 2rpx solid transparent;
  transition: all 0.2s;
}
.option.selected {
  border-color: $primary-color;
  background-color: rgba(43, 70, 254, 0.05);
}
.option.correct {
  border-color: $success-color;
  background-color: rgba(82, 196, 26, 0.08);
}
.option.wrong {
  border-color: $error-color;
  background-color: rgba(245, 34, 45, 0.05);
}
.option.disabled { opacity: 0.7; pointer-events: none; }
.option-label {
  font-weight: bold;
  margin-right: 24rpx;
  width: 40rpx;
  height: 40rpx;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 2rpx solid $border-color;
}
.option.selected .option-label {
  background-color: $primary-color;
  color: #fff;
  border-color: $primary-color;
}

.q-review { margin-top: 12rpx; display: flex; flex-direction: column; gap: 8rpx; }
.review-row { font-size: $font-size-sm; color: $text-secondary; }

.actions { display: flex; justify-content: center; }
</style>

