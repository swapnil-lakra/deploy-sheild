import type { Product } from "../types";

const API_BASE = import.meta.env.VITE_API_URL;

console.log(API_BASE)

class APIError extends Error {
  status: number;
  data: any;
  constructor(message: string, status: number, data: any) {
    super(message);
    this.name = 'APIError';
    this.status = status;
    this.data = data;
  }
}

async function request<T>(endpoint: string, options?: RequestInit): Promise<T> {
  const url = `${API_BASE}${endpoint}`;
  const response = await fetch(url, {
    ...options,
    headers: { 'Content-Type': 'application/json', ...options?.headers },
  });
  const data = await response.json().catch(() => null);
  if (!response.ok) {
    throw new APIError(data?.detail || data?.message || 'API Error', response.status, data);
  }
  return data as T;
}

export const api = {
  get: <T>(endpoint: string, params?: Record<string, any>) => {
    const query = params ? `?${new URLSearchParams(params).toString()}` : '';
    return request<T>(`${endpoint}${query}`);
  },
};

export const productAPI = {
  getAll: (params?: any) => api.get<Product[]>('/api/products/', params),
  getFeatured: (limit = 8) => api.get<Product[]>(`/api/products/featured?limit=${limit}`),
  getById: (id: number) => api.get<Product>(`/api/products/${id}`),
  getBySlug: (slug: string) => api.get<Product>(`/api/products/slug/${slug}`),
};