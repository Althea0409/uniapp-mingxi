// 通用类型定义

// API响应格式
export interface ApiResponse<T = any> {
  code: number;      // 200成功，其他失败
  message: string;   // 提示信息
  data: T;          // 返回数据
}

// 分页数据
export interface PageData<T> {
  list: T[];
  total: number;
  page: number;
  pageSize: number;
}

// 课程状态
export type CourseStatus = 'ongoing' | 'completed' | 'not-started';

// 作业状态
export type HomeworkStatus = 'pending' | 'submitted' | 'graded';

// 讨论热度
export type HotLevel = 'low' | 'medium' | 'high';

