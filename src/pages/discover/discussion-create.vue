<template>
  <view class="create-post-page">
    <view class="header">
      <text class="title">发起讨论</text>
      <text class="cancel" @tap="cancel">取消</text>
    </view>

    <scroll-view scroll-y class="content">
      <Card>
        <view class="form">
          <view class="form-item">
            <text class="label">标题</text>
            <input 
              class="input" 
              v-model="formData.title" 
              placeholder="请输入讨论标题"
              maxlength="50"
            />
            <text class="char-count">{{ formData.title.length }}/50</text>
          </view>

          <view class="form-item">
            <text class="label">内容</text>
            <textarea 
              class="textarea" 
              v-model="formData.content" 
              placeholder="分享你的想法、问题或经验..."
              maxlength="500"
              auto-height
            />
            <text class="char-count">{{ formData.content.length }}/500</text>
          </view>

          <view class="form-item">
            <text class="label">标签（可选）</text>
            <view class="tag-list">
              <text 
                v-for="tag in availableTags" 
                :key="tag"
                :class="['tag', { selected: formData.tags.includes(tag) }]"
                @tap="toggleTag(tag)"
              >
                {{ tag }}
              </text>
            </view>
          </view>

          <view class="form-item">
            <text class="label">匿名发布</text>
            <switch :checked="formData.anonymous" @change="onAnonymousChange" />
          </view>
        </view>
      </Card>
    </scroll-view>

    <view class="footer">
      <Button 
        text="发布" 
        type="primary" 
        size="large" 
        :disabled="!canSubmit || submitting"
        :loading="submitting"
        @click="submit"
      />
    </view>
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

const formData = ref({
  title: '',
  content: '',
  tags: [] as string[],
  anonymous: false
});

const submitting = ref(false);
const availableTags = ['学习技巧', '作业求助', '经验分享', '问题讨论', '资源推荐', '其他'];

const canSubmit = computed(() => {
  return formData.value.title.trim().length >= 5 && 
         formData.value.content.trim().length >= 10;
});

const toggleTag = (tag: string) => {
  const index = formData.value.tags.indexOf(tag);
  if (index >= 0) {
    formData.value.tags.splice(index, 1);
  } else {
    if (formData.value.tags.length < 3) {
      formData.value.tags.push(tag);
    } else {
      appStore.showToast('最多选择3个标签', 'none');
    }
  }
};

const onAnonymousChange = (e: any) => {
  formData.value.anonymous = e.detail.value;
};

const submit = async () => {
  if (!canSubmit.value || submitting.value) return;

  submitting.value = true;

  // 模拟提交延迟
  setTimeout(() => {
    const newPost = {
      id: `d${Date.now()}`,
      avatar: formData.value.anonymous ? 'static/avatar/default.svg' : userStore.userAvatar,
      username: formData.value.anonymous ? '匿名用户' : userStore.userName,
      time: '刚刚',
      isHot: false,
      title: formData.value.title.trim(),
      content: formData.value.content.trim(),
      views: 0,
      replies: 0,
      likes: 0,
      tags: formData.value.tags
    };

    // 保存到本地存储（实际应该调用API）
    const discussions = storage.get(StorageKeys.DISCUSSIONS) || [];
    discussions.unshift(newPost);
    storage.set(StorageKeys.DISCUSSIONS, discussions);

    appStore.showToast('发布成功', 'success');
    userStore.addPoints(10);
    
    setTimeout(() => {
      uni.navigateBack();
    }, 1000);
    
    submitting.value = false;
  }, 800);
};

const cancel = () => {
  if (formData.value.title || formData.value.content) {
    uni.showModal({
      title: '提示',
      content: '确定要放弃发布吗？',
      success: (res) => {
        if (res.confirm) {
          uni.navigateBack();
        }
      }
    });
  } else {
    uni.navigateBack();
  }
};
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';

.create-post-page {
  min-height: 100vh;
  background-color: $bg-color;
  display: flex;
  flex-direction: column;
}

.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 24rpx 32rpx;
  background: $card-bg;
  border-bottom: 1rpx solid $divider-color;
}

.title {
  font-size: $font-size-lg;
  font-weight: bold;
  color: $text-primary;
}

.cancel {
  font-size: $font-size-base;
  color: $text-secondary;
  cursor: pointer;
}

.content {
  flex: 1;
  padding: 24rpx 32rpx;
  box-sizing: border-box;
}

.form {
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

.input {
  height: 80rpx;
  background: $card-bg;
  border-radius: $border-radius;
  padding: 0 24rpx;
  font-size: $font-size-base;
  color: $text-primary;
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

.char-count {
  font-size: $font-size-xs;
  color: $text-placeholder;
  text-align: right;
}

.tag-list {
  display: flex;
  flex-wrap: wrap;
  gap: 12rpx;
}

.tag {
  padding: 12rpx 24rpx;
  background: $bg-color;
  border-radius: 24rpx;
  font-size: $font-size-sm;
  color: $text-secondary;
  border: 2rpx solid transparent;
  cursor: pointer;
}

.tag.selected {
  background: rgba(43, 70, 254, 0.1);
  color: $primary-color;
  border-color: $primary-color;
}

.footer {
  padding: 24rpx 32rpx calc(24rpx + var(--window-bottom)) 32rpx;
  background: $card-bg;
  border-top: 1rpx solid $divider-color;
}
</style>

