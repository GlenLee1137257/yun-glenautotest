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
  const shallowCloneObj = JSON.parse(JSON.stringify(obj))

  Object.entries(shallowCloneObj).forEach(([key, value]) => {
    if (typeof value === 'object') {
      shallowCloneObj[key] = simplyObjectDeepClone(value as T[typeof key])
    }
  })

  return shallowCloneObj
}
