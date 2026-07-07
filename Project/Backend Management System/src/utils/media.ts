const API_ORIGIN = 'http://localhost:8081'

export const resolveMediaUrl = (value?: string | null) => {
  const raw = (value || '').trim()
  if (!raw) return ''
  if (/^https?:\/\//i.test(raw) || raw.startsWith('data:image/')) return raw
  if (raw.startsWith('/')) return `${API_ORIGIN}${raw}`
  return `${API_ORIGIN}/${raw}`
}

