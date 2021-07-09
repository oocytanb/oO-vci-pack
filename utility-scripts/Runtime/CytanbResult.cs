// SPDX-License-Identifier: MIT
// Copyright (c) 2021 oO (https://github.com/oocytanb)

using System;
using System.Collections.Generic;

namespace cytanb
{
    public readonly struct Result<T, E>
        : IEquatable<Result<T, E>>, IEnumerable<T>
    {
        public bool IsOk { get; }

        public bool IsError => !IsOk;

        private readonly T value;

        public T Value {
            get {
                if (IsError)
                {
                    throw new InvalidOperationException();
                }
                return value;
            }
        }

        public E Error {
            get {
                if (IsOk)
                {
                    throw new InvalidOperationException();
                }
                return error;
            }
        }

        private readonly E error;

        private Result(bool isOk, in T value, in E error)
        {
            IsOk = isOk;
            this.value = value;
            this.error = error;
        }

        public static Result<T, E> Ok(in T value)
        {
            return new Result<T, E>(true, value, default);
        }

        public static Result<T, E> Err(in E error)
        {
            return new Result<T, E>(false, default, error);
        }

        public T ValueOrDefault(in T defaultValue)
        {
            return IsOk ? value : defaultValue;
        }

        public override string ToString()
        {
            return IsOk ? $@"Ok {value}" : $@"Err {error}";
        }

        public override int GetHashCode()
        {
            unchecked
            {
                const int m = -1521134295;
                const int n = 2031547472 * m;
                var b = IsOk;
                return b
                    ? (
                        (n + 1) * m +
                        EqualityComparer<T>.Default.GetHashCode(value)
                      )
                    : (
                        n * m +
                        EqualityComparer<E>.Default.GetHashCode(error)
                      );
            }
        }

        public bool Equals(Result<T, E> other)
        {
            var b = IsOk;
            return b == other.IsOk && (
                b
                ? EqualityComparer<T>.Default
                    .Equals(value, other.value)
                : EqualityComparer<E>.Default
                    .Equals(error, other.error)
            );
        }

        public override bool Equals(object obj)
        {
            return obj is Result<T, E> result && Equals(result);
        }

        public static bool operator ==(Result<T, E> lhs, Result<T, E> rhs)
        {
            return lhs.Equals(rhs);
        }

        public static bool operator !=(Result<T, E> lhs, Result<T, E> rhs)
        {
            return !(lhs == rhs);
        }

        public OptionEnumerator<T> GetEnumerator()
        {
            return new OptionEnumerator<T>(IsOk, value);
        }

        IEnumerator<T> IEnumerable<T>.GetEnumerator()
        {
            return GetEnumerator();
        }

        System.Collections.IEnumerator
            System.Collections.IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }

        public void Iter(Action<T> action)
        {
            if (IsOk)
            {
                action(value);
            }
        }

        public void IterError(Action<E> action)
        {
            if (IsError)
            {
                action(error);
            }
        }

        public Result<U, E> AndThen<U>(Func<T, Result<U, E>> f)
        {
            return IsOk ? f(value) : new Result<U, E>(false, default, error);
        }

        public Result<T, E> AndThen(Func<T, Result<T, E>> f)
        {
            return IsOk ? f(value) : this;
        }

        public Result<U, E> Map<U>(Func<T, U> f)
        {
            return IsOk
                ? new Result<U, E>(true, f(value), default)
                : new Result<U, E>(false, default, error);
        }

        public Result<T, E> Map(Func<T, T> f)
        {
            return IsOk ? new Result<T, E>(true, f(value), error) : this;
        }

        public Result<T, F> MapError<F>(Func<E, F> f)
        {
            return IsOk
                ? new Result<T, F>(true, value, default)
                : new Result<T, F>(false, value, f(error));
        }

        public Result<T, E> MapError(Func<E, E> f)
        {
            return IsOk
                ? this
                : new Result<T, E>(false, value, f(error));
        }

        public Option<T> ToOption()
        {
            return IsOk
                ? Option<T>.Some(value)
                : Option<T>.None;
        }
        
        public Option<E> ErrorToOption()
        {
            return IsError
                ? Option<E>.Some(error)
                : Option<E>.None;
        }
    }
}
