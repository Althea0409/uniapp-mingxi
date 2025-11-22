<template>
  <view class="help-page">
    <scroll-view scroll-y class="content">
      <!-- 帮助中心 -->
      <Card>
        <view class="section">
          <text class="section-title">📚 使用指南</text>
          <view class="help-list">
            <view 
              v-for="(item, index) in helpItems" 
              :key="index"
              class="help-item"
              @tap="viewHelp(item)"
            >
              <text class="help-icon">{{ item.icon }}</text>
              <view class="help-content">
                <text class="help-title">{{ item.title }}</text>
                <text class="help-desc">{{ item.desc }}</text>
              </view>
              <text class="help-arrow">→</text>
            </view>
          </view>
        </view>
      </Card>

      <!-- 常见问题 -->
      <Card>
        <view class="section">
          <text class="section-title">❓ 常见问题</text>
          <view class="faq-list">
            <view 
              v-for="(faq, index) in faqs" 
              :key="index"
              class="faq-item"
              @tap="toggleFaq(index)"
            >
              <view class="faq-question">
                <text class="faq-text">{{ faq.question }}</text>
                <text class="faq-icon">{{ expandedFaqs.includes(index) ? '▼' : '▶' }}</text>
              </view>
              <view v-if="expandedFaqs.includes(index)" class="faq-answer">
                <text class="faq-answer-text">{{ faq.answer }}</text>
              </view>
            </view>
          </view>
        </view>
      </Card>

      <!-- 意见反馈 -->
      <Card>
        <view class="section">
          <text class="section-title">💬 意见反馈</text>
          <view class="feedback-form">
            <view class="form-item">
              <text class="label">反馈类型</text>
              <picker 
                mode="selector" 
                :range="feedbackTypes" 
                @change="onFeedbackTypeChange"
              >
                <view class="picker-view">
                  <text :class="['picker-text', { placeholder: !selectedFeedbackType }]">
                    {{ selectedFeedbackType || '请选择反馈类型' }}
                  </text>
                  <text class="picker-arrow">▼</text>
                </view>
              </picker>
            </view>

            <view class="form-item">
              <text class="label">反馈内容</text>
              <textarea 
                class="textarea" 
                v-model="feedbackContent" 
                placeholder="请详细描述你的问题或建议..."
                maxlength="500"
                auto-height
              />
              <text class="char-count">{{ feedbackContent.length }}/500</text>
            </view>

            <view class="form-item">
              <text class="label">联系方式（可选）</text>
              <input 
                class="input" 
                v-model="contact" 
                placeholder="手机号或邮箱"
              />
            </view>

            <Button 
              text="提交反馈" 
              type="primary" 
              size="large" 
              :disabled="!canSubmit || submitting"
              :loading="submitting"
              @click="submitFeedback"
            />
          </view>
        </view>
      </Card>

      <!-- 联系我们 -->
      <Card>
        <view class="section">
          <text class="section-title">📞 联系我们</text>
          <view class="contact-list">
            <view class="contact-item" @tap="copyContact('客服电话', '400-123-4567')">
              <text class="contact-icon">📞</text>
              <view class="contact-info">
                <text class="contact-label">客服电话</text>
                <text class="contact-value">400-123-4567</text>
              </view>
              <text class="contact-copy">复制</text>
            </view>
            <view class="contact-item" @tap="copyContact('客服邮箱', 'support@mingxi.com')">
              <text class="contact-icon">📧</text>
              <view class="contact-info">
                <text class="contact-label">客服邮箱</text>
                <text class="contact-value">support@mingxi.com</text>
              </view>
              <text class="contact-copy">复制</text>
            </view>
            <view class="contact-item" @tap="copyContact('官方QQ群', '123456789')">
              <text class="contact-icon">💬</text>
              <view class="contact-info">
                <text class="contact-label">官方QQ群</text>
                <text class="contact-value">123456789</text>
              </view>
              <text class="contact-copy">复制</text>
            </view>
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
import { storage, StorageKeys } from '@/utils/storage';

const appStore = useAppStore();
const userStore = useUserStore();

const helpItems = ref([
  {
    icon: '📖',
    title: '如何开始学习',
    desc: '了解如何选择课程、完成作业和预习任务'
  },
  {
    icon: '🏆',
    title: '积分与成就',
    desc: '了解如何获得积分、解锁成就和提升等级'
  },
  {
    icon: '🤖',
    title: 'AI助手使用',
    desc: '学习如何使用AI助手解答问题'
  },
  {
    icon: '📊',
    title: '学习数据分析',
    desc: '查看学习报告和学生画像'
  }
]);

const faqs = ref([
  {
    question: '如何提交作业？',
    answer: '在学习中心找到待完成的作业，点击进入作业详情页，完成题目后点击"提交作业"按钮即可。系统会自动批改选择题和填空题，问答题需要等待老师批改。'
  },
  {
    question: '积分有什么用？',
    answer: '积分可以用来解锁成就、提升等级。完成学习任务、参与讨论、获得成就等都可以获得积分。'
  },
  {
    question: '如何查看学习进度？',
    answer: '在首页可以看到本周学习数据概览，点击"查看详情"可以进入学习评估页面查看详细的学习指标和雷达图。'
  },
  {
    question: '忘记密码怎么办？',
    answer: '请联系管理员重置密码，或通过客服电话400-123-4567寻求帮助。'
  },
  {
    question: '如何修改个人信息？',
    answer: '在个人中心点击头像或个人信息区域，可以进入编辑模式修改姓名、学校、年级、班级等信息。'
  }
]);

const expandedFaqs = ref<number[]>([]);

const toggleFaq = (index: number) => {
  const i = expandedFaqs.value.indexOf(index);
  if (i >= 0) {
    expandedFaqs.value.splice(i, 1);
  } else {
    expandedFaqs.value.push(index);
  }
};

const viewHelp = (item: any) => {
  appStore.showToast(`查看：${item.title}`, 'none');
  // 可以跳转到详细的帮助页面
};

const feedbackTypes = ['功能建议', '问题反馈', '内容错误', '其他'];
const selectedFeedbackType = ref('');
const feedbackContent = ref('');
const contact = ref('');
const submitting = ref(false);

const canSubmit = computed(() => {
  return selectedFeedbackType.value && feedbackContent.value.trim().length >= 10;
});

const onFeedbackTypeChange = (e: any) => {
  selectedFeedbackType.value = feedbackTypes[e.detail.value];
};

const submitFeedback = () => {
  if (!canSubmit.value || submitting.value) return;

  submitting.value = true;

  // 保存反馈到本地存储
  const feedback = {
    id: `fb${Date.now()}`,
    type: selectedFeedbackType.value,
    content: feedbackContent.value.trim(),
    contact: contact.value.trim(),
    time: new Date().toISOString(),
    userId: userStore.userId
  };

  const feedbacks = storage.get(StorageKeys.FEEDBACKS) || [];
  feedbacks.push(feedback);
  storage.set(StorageKeys.FEEDBACKS, feedbacks);

  setTimeout(() => {
    appStore.showToast('反馈提交成功，感谢你的建议！', 'success');
    userStore.addPoints(5);
    
    // 清空表单
    selectedFeedbackType.value = '';
    feedbackContent.value = '';
    contact.value = '';
    submitting.value = false;
  }, 800);
};

const copyContact = (label: string, value: string) => {
  uni.setClipboardData({
    data: value,
    success: () => {
      appStore.showToast(`已复制${label}`, 'success');
    }
  });
};
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.help-page {
  min-height: 100vh;
  background-color: $bg-color;
}

.content {
  padding: 24rpx 32rpx calc(24rpx + var(--window-bottom)) 32rpx;
  box-sizing: border-box;
}

.section {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}

.section-title {
  font-size: $font-size-lg;
  font-weight: bold;
  color: $text-primary;
  margin-bottom: 8rpx;
}

.help-list {
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}

.help-item {
  display: flex;
  align-items: center;
  gap: 16rpx;
  padding: 16rpx;
  background: $bg-color;
  border-radius: $border-radius;
}

.help-icon {
  font-size: 40rpx;
  flex-shrink: 0;
}

.help-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4rpx;
}

.help-title {
  font-size: $font-size-base;
  color: $text-primary;
  font-weight: 500;
}

.help-desc {
  font-size: $font-size-xs;
  color: $text-secondary;
}

.help-arrow {
  font-size: $font-size-lg;
  color: $text-placeholder;
}

.faq-list {
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}

.faq-item {
  background: $bg-color;
  border-radius: $border-radius;
  overflow: hidden;
}

.faq-question {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16rpx;
}

.faq-text {
  flex: 1;
  font-size: $font-size-base;
  color: $text-primary;
  font-weight: 500;
}

.faq-icon {
  font-size: $font-size-sm;
  color: $text-placeholder;
}

.faq-answer {
  padding: 0 16rpx 16rpx 16rpx;
}

.faq-answer-text {
  font-size: $font-size-sm;
  color: $text-secondary;
  line-height: 1.8;
}

.feedback-form {
  display: flex;
  flex-direction: column;
  gap: 24rpx;
}

.form-item {
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}

.label {
  font-size: $font-size-base;
  color: $text-primary;
  font-weight: 500;
}

.picker-view {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 80rpx;
  background: $card-bg;
  border-radius: $border-radius;
  padding: 0 24rpx;
}

.picker-text {
  font-size: $font-size-base;
  color: $text-primary;
  
  &.placeholder {
    color: $text-placeholder;
  }
}

.picker-arrow {
  font-size: $font-size-xs;
  color: $text-placeholder;
}

.textarea {
  min-height: 200rpx;
  background: $card-bg;
  border-radius: $border-radius;
  padding: 24rpx;
  font-size: $font-size-base;
  color: $text-primary;
  line-height: 1.6;
}

.input {
  height: 80rpx;
  background: $card-bg;
  border-radius: $border-radius;
  padding: 0 24rpx;
  font-size: $font-size-base;
  color: $text-primary;
}

.char-count {
  font-size: $font-size-xs;
  color: $text-placeholder;
  text-align: right;
}

.contact-list {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}

.contact-item {
  display: flex;
  align-items: center;
  gap: 16rpx;
  padding: 16rpx;
  background: $bg-color;
  border-radius: $border-radius;
}

.contact-icon {
  font-size: 40rpx;
  flex-shrink: 0;
}

.contact-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4rpx;
}

.contact-label {
  font-size: $font-size-sm;
  color: $text-secondary;
}

.contact-value {
  font-size: $font-size-base;
  color: $text-primary;
  font-weight: 500;
}

.contact-copy {
  font-size: $font-size-sm;
  color: $primary-color;
  cursor: pointer;
}
</style>

