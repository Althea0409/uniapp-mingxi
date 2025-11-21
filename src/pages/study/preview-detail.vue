<template>
  <view class="preview-detail-page">
    <Loading v-if="loading" text="正在加载预习..." />
    <Card v-else>
      <text class="title">{{ pv.title }}</text>
      <text class="sub">课程：{{ pv.courseName }} · 建议预习时长：{{ pv.duration }}分钟 · 发布时间：{{ pv.publishTime }}</text>
    </Card>

    <Card>
      <view class="section">
        <text class="section-title">预习内容</text>
        <view class="content-list">
          <view class="content-item" v-for="(c, i) in pv.content" :key="i">
            <text class="bullet">•</text>
            <text class="text">{{ c }}</text>
          </view>
        </view>
      </view>
    </Card>

    <Card>
      <view class="section">
        <text class="section-title">预习笔记</text>
        <textarea class="note-input" :value="pv.notes" placeholder="在此记录要点与疑问" @input="onInput('notes', $event)"
          auto-height />
        <text class="section-title" style="margin-top:16rpx;">预习疑问</text>
        <textarea class="note-input" :value="pv.questions" placeholder="在此记录你的问题" @input="onInput('questions', $event)"
          auto-height />
      </view>
    </Card>

    <Card>
      <view class="actions">
        <Button :text="saving ? '保存中' : '标记完成'" :type="pv.completed ? 'secondary' : 'primary'" size="large"
          :disabled="saving" @click="toggleComplete" />
      </view>
    </Card>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { onLoad } from '@dcloudio/uni-app';
import Card from '@/components/common/Card.vue';
import Button from '@/components/common/Button.vue';
import { useAppStore } from '@/stores/app';
import homeworkJson from '@/mock/homework.json';
import { storage, StorageKeys } from '@/utils/storage';
import Loading from '@/components/common/Loading.vue';

const appStore = useAppStore();

const loading = ref(true);
const pv = ref<any>({
  id: '',
  courseId: '',
  courseName: '',
  title: '',
  duration: 0,
  publishTime: '',
  content: [],
  completed: false,
  notes: '',
  questions: ''
});

function loadPreview(id: string) {
  loading.value = true;
  const list = ((storage.get(StorageKeys.PREVIEW) as any) || (homeworkJson as any).preview) || [];
  const data = list.find((x: any) => x.id === id);
  if (!data) {
    loading.value = false;
    appStore.showToast('预习任务不存在', 'none');
    return;
  }
  pv.value = {
    id: data.id,
    courseId: data.courseId,
    courseName: data.courseName,
    title: data.title,
    duration: data.duration,
    publishTime: data.publishTime || '—',
    content: data.content || [],
    completed: !!data.completed,
    notes: data.notes || '',
    questions: data.questions || ''
  };
  loading.value = false;
}

onLoad((options: any) => {
  const id = options?.id || '';
  loadPreview(id);
});

const saving = ref(false);
const toggleComplete = () => {
  if (saving.value) return;
  saving.value = true;
  pv.value.completed = !pv.value.completed;
  persistPreview();
  appStore.showToast(pv.value.completed ? '已标记完成' : '已取消完成', 'success');
  saving.value = false;
};

function onInput(field: 'notes' | 'questions', e: any) {
  const val = e?.detail?.value || '';
  (pv.value as any)[field] = val;
  persistPreview();
}

function persistPreview() {
  const list = (storage.get(StorageKeys.PREVIEW) as any) || (homeworkJson as any).preview || [];
  const idx = list.findIndex((x: any) => x.id === pv.value.id);
  const item = { ...pv.value } as any;
  if (idx >= 0) list[idx] = item; else list.push(item);
  storage.set(StorageKeys.PREVIEW, list);
}
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.preview-detail-page {
  padding: 24rpx 32rpx;
}

.title {
  font-size: $font-size-xl;
  font-weight: bold;
  color: $text-primary;
}

.sub {
  display: block;
  margin-top: 8rpx;
  font-size: $font-size-sm;
  color: $text-secondary;
}

.section-title {
  font-size: $font-size-lg;
  font-weight: bold;
  color: $text-primary;
  margin-bottom: 12rpx;
}

.content-list {
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}

.content-item {
  display: flex;
  gap: 12rpx;
}

.bullet {
  font-size: 32rpx;
}

.text {
  flex: 1;
  font-size: $font-size-base;
  color: $text-primary;
  line-height: 1.6;
}

.actions {
  display: flex;
  justify-content: center;
}

.note-input {
  background-color: $bg-color;
  border-radius: $border-radius;
  padding: 20rpx;
  font-size: $font-size-base;
  width: 100%;
  box-sizing: border-box;
}
</style>
