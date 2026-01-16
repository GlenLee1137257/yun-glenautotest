/* eslint-disable unicorn/prefer-string-replace-all */
export function handleParams(url: string, params: object): string {
  if (params && Object.keys(params).length > 0) {
    const hasQuery = url.includes('?')

    const queryString = Object.entries(params)
      .map(([key, value]) => `${key}=${value}`)
      .join('&')

    return `${url}${hasQuery ? '&' : '?'}${queryString}`
  } else {
    return url
  }
}

export function handleParamsWithoutUrl(params: object): string {
  return Object.entries(params)
    .map(([key, value]) => `${key}=${value}`)
    .join('&')
}

export function objectSerializer<
  T = any,
  U extends boolean = true,
  P = U extends true ? T[] : T,
>(pairData: P) {
  return JSON.stringify(pairData, null, 0)
}

export function objectDeserializer<T = any, U extends boolean = true>(
  pair: string,
  isArray?: U,
): U extends true ? T[] : T {
  return pair ? JSON.parse(pair) : isArray ? [] : {}
}

export function simplyObjectDeepClone<T extends Record<string, any>>(
  obj: T,
): T {
  // 处理 null 和 undefined 的情况
  if (obj === null || obj === undefined) {
    return obj
  }

  const shallowCloneObj = JSON.parse(JSON.stringify(obj))

  // 处理 JSON.parse 可能返回 null 的情况（当 obj 是 null 时）
  if (shallowCloneObj === null || typeof shallowCloneObj !== 'object') {
    return shallowCloneObj
  }

  // 处理数组的情况
  if (Array.isArray(shallowCloneObj)) {
    return shallowCloneObj.map(item =>
      typeof item === 'object' && item !== null
        ? simplyObjectDeepClone(item as T)
        : item,
    ) as T
  }

  Object.entries(shallowCloneObj).forEach(([key, value]) => {
    if (typeof value === 'object' && value !== null) {
      shallowCloneObj[key] = simplyObjectDeepClone(value as T[typeof key])
    }
  })

  return shallowCloneObj
}
