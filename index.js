function trampoline(fn) {
  return function () {
    var result = fn.apply(fn, arguments);
    while (typeof result === 'function') {
      result = result();
    }
    return result;
  };
}

function fibonacci(count, a = 1, b = 1) {
  const acc = [];

  function inner(count, a, b) {
    if (!count) {
      return acc;
    }
    acc.push(a);
    return () => inner(count - 1, b, a + b);
  }

  return trampoline(inner)(count, a, b);
}

console.log(fibonacci(10000));
