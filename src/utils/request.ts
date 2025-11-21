// Mock请求工具封装
import type { ApiResponse } from '@/types/common';

/**
 * Mock延迟（模拟网络请求）
 * @param ms 延迟毫秒数
 */
function delay(ms: number = 300): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}

/**
 * Mock请求工具类
 */
class Request {
  /**
   * 模拟GET请求
   * @param url 请求路径
   * @param data 请求参数
   * @returns Promise<ApiResponse>
   */
  async get<T = any>(url: string, data?: any): Promise<ApiResponse<T>> {
    const isH5 = typeof window !== 'undefined';
    if (isH5) {
      const u = new URL(url, window.location.origin);
      if (data) Object.entries(data).forEach(([k, v]) => { if (v !== undefined && v !== null) u.searchParams.set(k, String(v)); });
      const res = await fetch(u.toString());
      const txt = await res.text();
      const parsed = txt ? JSON.parse(txt) : ({} as T);
      return { code: res.status, message: res.ok ? '请求成功' : '请求失败', data: parsed };
    }
    const [err, resp] = await new Promise<[any, any]>((resolve) => {
      uni.request({ url, method: 'GET', data, success: (r) => resolve([null, r]), fail: (e) => resolve([e, null]) });
    });
    if (err) return { code: 500, message: '网络错误', data: null as any };
    return { code: resp.statusCode, message: resp.statusCode === 200 ? '请求成功' : '请求失败', data: resp.data as T };
  }

  /**
   * 模拟POST请求
   * @param url 请求路径
   * @param data 请求参数
   * @returns Promise<ApiResponse>
   */
  async post<T = any>(url: string, data?: any): Promise<ApiResponse<T>> {
    const isH5 = typeof window !== 'undefined';
    if (isH5) {
      const res = await fetch(url, { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify(data || {}) });
      const txt = await res.text();
      const parsed = txt ? JSON.parse(txt) : ({} as T);
      return { code: res.status, message: res.ok ? '请求成功' : '请求失败', data: parsed };
    }
    const [err, resp] = await new Promise<[any, any]>((resolve) => {
      uni.request({ url, method: 'POST', data, header: { 'content-type': 'application/json' }, success: (r) => resolve([null, r]), fail: (e) => resolve([e, null]) });
    });
    if (err) return { code: 500, message: '网络错误', data: null as any };
    return { code: resp.statusCode, message: resp.statusCode === 200 || resp.statusCode === 201 ? '请求成功' : '请求失败', data: resp.data as T };
  }

  /**
   * 模拟PUT请求
   * @param url 请求路径
   * @param data 请求参数
   * @returns Promise<ApiResponse>
   */
  async put<T = any>(url: string, data?: any): Promise<ApiResponse<T>> {
    const isH5 = typeof window !== 'undefined';
    if (isH5) {
      const res = await fetch(url, { method: 'PUT', headers: { 'content-type': 'application/json' }, body: JSON.stringify(data || {}) });
      const txt = await res.text();
      const parsed = txt ? JSON.parse(txt) : ({} as T);
      return { code: res.status, message: res.ok ? '请求成功' : '请求失败', data: parsed };
    }
    const [err, resp] = await new Promise<[any, any]>((resolve) => {
      uni.request({ url, method: 'PUT', data, header: { 'content-type': 'application/json' }, success: (r) => resolve([null, r]), fail: (e) => resolve([e, null]) });
    });
    if (err) return { code: 500, message: '网络错误', data: null as any };
    return { code: resp.statusCode, message: resp.statusCode === 200 ? '请求成功' : '请求失败', data: resp.data as T };
  }

  /**
   * 模拟DELETE请求
   * @param url 请求路径
   * @param data 请求参数
   * @returns Promise<ApiResponse>
   */
  async delete<T = any>(url: string, data?: any): Promise<ApiResponse<T>> {
    const isH5 = typeof window !== 'undefined';
    if (isH5) {
      const u = new URL(url, window.location.origin);
      if (data) Object.entries(data).forEach(([k, v]) => { if (v !== undefined && v !== null) u.searchParams.set(k, String(v)); });
      const res = await fetch(u.toString(), { method: 'DELETE' });
      const txt = await res.text();
      const parsed = txt ? JSON.parse(txt) : ({} as T);
      return { code: res.status, message: res.ok ? '请求成功' : '请求失败', data: parsed };
    }
    const [err, resp] = await new Promise<[any, any]>((resolve) => {
      uni.request({ url, method: 'DELETE', data, success: (r) => resolve([null, r]), fail: (e) => resolve([e, null]) });
    });
    if (err) return { code: 500, message: '网络错误', data: null as any };
    return { code: resp.statusCode, message: resp.statusCode === 200 ? '请求成功' : '请求失败', data: resp.data as T };
  }

  /**
   * 创建成功响应
   * @param data 响应数据
   * @param message 提示信息
   * @returns ApiResponse
   */
  success<T = any>(data: T, message: string = '操作成功'): ApiResponse<T> {
    return {
      code: 200,
      message,
      data,
    };
  }

  /**
   * 创建失败响应
   * @param message 错误信息
   * @param code 错误码
   * @returns ApiResponse
   */
  error(message: string = '操作失败', code: number = 500): ApiResponse {
    return {
      code,
      message,
      data: null,
    };
  }

  /**
   * 显示成功提示
   * @param message 提示信息
   */
  showSuccess(message: string): void {
    uni.showToast({
      title: message,
      icon: 'success',
      duration: 2000,
    });
  }

  /**
   * 显示错误提示
   * @param message 提示信息
   */
  showError(message: string): void {
    uni.showToast({
      title: message,
      icon: 'none',
      duration: 2000,
    });
  }

  /**
   * 显示加载中
   * @param message 提示信息
   */
  showLoading(message: string = '加载中...'): void {
    uni.showLoading({
      title: message,
      mask: true,
    });
  }

  /**
   * 隐藏加载中
   */
  hideLoading(): void {
    uni.hideLoading();
  }
}

// 导出单例
export const request = new Request();

