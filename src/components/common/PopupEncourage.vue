<template>
  <view v-if="visible" class="popup-mask" @tap="onClose">
    <view class="popup-card" @tap.stop>
      <view class="emoji">{{ emoji }}</view>
      <text class="text">{{ text }}</text>
      <view class="buttons">
        <Button v-if="type==='fatigue'" text="休息5分钟" type="secondary" size="small" @click="onClose" />
        <Button text="继续学习" type="primary" size="small" @click="onClose" />
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import Button from '@/components/common/Button.vue';

interface Props { visible?: boolean; type?: 'fatigue'|'encourage'|'celebration'|'daily'; text?: string }
const props = withDefaults(defineProps<Props>(), { visible: false, type: 'encourage', text: '加油！你很棒！' });
const emit = defineEmits<{ close: [] }>();

const emoji = computed(() => {
  switch (props.type) {
    case 'fatigue': return '😴';
    case 'celebration': return '🎉';
    case 'daily': return '📅';
    default: return '💪';
  }
});

const onClose = () => emit('close');
</script>

<style lang="scss" scoped>
@import '@/styles/variables.scss';
.popup-mask { position: fixed; inset: 0; background: rgba(0,0,0,0.35); z-index: $z-index-modal; display: flex; align-items: center; justify-content: center; }
.popup-card { width: 80%; background: #FFFFFF; border-radius: $border-radius; padding: 24rpx; box-shadow: 0 8rpx 24rpx rgba(0,0,0,0.2); display: flex; flex-direction: column; align-items: center; gap: 12rpx; }
.emoji { font-size: 64rpx; }
.text { font-size: $font-size-base; color: $text-primary; text-align: center; }
.buttons { display: flex; gap: 12rpx; margin-top: 8rpx; }
</style>