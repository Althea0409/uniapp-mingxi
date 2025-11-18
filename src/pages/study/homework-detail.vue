<template>
  <view class="homework-detail-page">
    <Card>
      <view class="header">
        <text class="title">{{ hw.title }}</text>
        <view :class="['status', hw.status]">{{ statusText }}</view>
      </view>
      <text class="sub">课程：{{ hw.courseName }} · 截止：{{ hw.deadline }}</text>
      <text class="desc">题型：{{ hw.questionTypes }}</text>
    </Card>

    <Card>
      <view class="section">
        <text class="section-title">作业内容（占位）</text>
        <view class="question" v-for="(q, i) in questions" :key="i">
          <text class="q-title">{{ i + 1 }}. {{ q.title }}</text>
          <input class="q-input" v-model="q.answer" placeholder="在此填写答案" />
        </view>
      </view>
    </Card>

    <Card>
      <view class="actions">
        <Button text="提交作业" type="primary" size="large" @click="submitHomework" />
      </view>
    </Card>
  </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import Card from '@/components/common/Card.vue';
import Button from '@/components/common/Button.vue';
import { useAppStore } from '@/stores/app';
import { useUserStore } from '@/stores/user';

const appStore = useAppStore();
const userStore = useUserStore();

const hw = ref({
  id: 'h001',
  courseId: 'c002',
  courseName: '英语精读',
  title: 'Unit 5 阅读与词汇练习',
  deadline: '2025-11-20 23:59',
  description: '阅读理解+词汇填空',
  questionTypes: '选择题5道 + 填空题5道',
  status: 'pending'
});

const statusText = computed(() => {
  switch (hw.value.status) {
    case 'pending': return '待提交';
    case 'submitted': return '已提交';
    case 'graded': return '已批改';
    default: return '';
  }
});

const questions = ref([
  { title: '阅读理解题（节选）', answer: '', key: 'A' },
  { title: '词汇填空（5空）', answer: '', key: 'memory' },
]);

const submitHomework = async () => {
  const ok = await appStore.showConfirm('确认提交作业吗？');
  if (!ok) return;
  let wrong = 0;
  for (const q of questions.value) {
    const a = (q.answer||'').trim();
    const k = (q as any).key;
    if (!a) wrong++;
    else if (k && a.toLowerCase() !== String(k).toLowerCase()) wrong++;
  }
  if (wrong > 0) {
    appStore.recordWrongAnswer(wrong);
    appStore.showToast(`有${wrong}题错误或未作答，建议继续练习`, 'none');
  } else {
    appStore.resetWrongAnswer();
    hw.value.status = 'submitted';
    appStore.showToast('已提交作业，等待教师批改', 'success');
    userStore.addPoints(30);
    appStore.triggerEncouragement('celebration');
  }
};
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

.section-title { font-size: $font-size-lg; font-weight: bold; color: $text-primary; margin-bottom: 16rpx; }
.question { margin-bottom: 16rpx; }
.q-title { display: block; font-size: $font-size-base; color: $text-primary; margin-bottom: 8rpx; }
.q-input { background-color: $bg-color; border-radius: $border-radius; padding: 16rpx; font-size: $font-size-base; }

.actions { display: flex; justify-content: center; }
</style>

