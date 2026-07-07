import api from './index'

export async function uploadAdminImage(file: File): Promise<string> {
  const form = new FormData()
  form.append('file', file)
  const res: any = await api.post('/api/admin/upload/image', form)
  if (res?.code !== 200 || !res?.data?.url) {
    throw new Error(res?.message || `图片上传失败（code=${res?.code ?? 'unknown'}）`)
  }
  return res.data.url
}

export async function uploadAdminVideo(file: File): Promise<string> {
  const form = new FormData()
  form.append('file', file)
  const res: any = await api.post('/api/admin/upload/video', form)
  if (res?.code !== 200 || !res?.data?.url) {
    throw new Error(res?.message || '视频上传失败')
  }
  return res.data.url
}
