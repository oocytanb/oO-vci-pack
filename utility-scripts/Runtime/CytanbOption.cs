// SPDX-License-Identifier: MIT
// Copyright (c) 2021 oO (https://github.com/oocytanb)

using System;
using System.Collections.Generic;

namespace cytanb
{
    public struct OptionEnumerator<T>
        : IEnumerator<T>, System.Collections.IEnumerator
    {
        private bool valueExists;

        private T current;

        private int position;

        internal OptionEnumerator(bool valueExists, in T value)
        {
            this.valueExists = valueExists;
            this.current = value;
            this.position = valueExists ? -1 : 1;
        }

        public void Dispose()
        {
        }

        public bool MoveNext()
        {
            ++position;
            return position <= 0;
        }

        public T Current {
            get {
                if (position != 0) {
                    throw new InvalidOperationException();
                }
                return current;
            }
        }

        T IEnumerator<T>.Current {
            get {
                return Current;
            }
        }

        Object System.Collections.IEnumerator.Current {
            get {
                return Current;
            }
        }

        void System.Collections.IEnumerator.Reset()
        {
            position = valueExists ? -1 : 1;
        }
    }

    public readonly struct Option<T>
        : IEquatable<Option<T>>, IEnumerable<T>
    {
        public bool IsSome { get; }

        public bool IsNone => !IsSome;

        private readonly T value;

        public T Value {
            get {
                if (IsNone)
                {
                    throw new InvalidOperationException();
                }
                return value;
            }
        }

        private Option(bool isSome, in T value)
        {
            IsSome = isSome;
            this.value = value;
        }

        public static Option<T> Some(in T value)
        {
            return new Option<T>(true, value);
        }

        public static Option<T> None => new Option<T>(false, default);

        public T ValueOrDefault(in T defaultValue)
        {
            return IsSome ? value : defaultValue;
        }

        public override string ToString()
        {
            return IsSome ? $@"Some {value}" : "None";
        }

        public override int GetHashCode()
        {
            unchecked
            {
                const int m = -1521134295;
                const int n = 2031547472 * m;
                var b = IsSome;
                return b
                    ? (
                        (n + 1) * m +
                        EqualityComparer<T>.Default.GetHashCode(value)
                      )
                    : (
                        n * m
                      );
            }
        }

        public bool Equals(Option<T> other)
        {
            var b = IsSome;
            return b == other.IsSome && (
                !b || EqualityComparer<T>.Default.Equals(value, other.value)
            );
        }

        public override bool Equals(object obj)
        {
            return obj is Option<T> result && Equals(result);
        }

        public static bool operator ==(Option<T> lhs, Option<T> rhs)
        {
            return lhs.Equals(rhs);
        }

        public static bool operator !=(Option<T> lhs, Option<T> rhs)
        {
            return !(lhs == rhs);
        }

        public OptionEnumerator<T> GetEnumerator()
        {
            return new OptionEnumerator<T>(IsSome, value);
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
            if (IsSome)
            {
                action(value);
            }
        }

        public Option<U> AndThen<U>(Func<T, Option<U>> f)
        {
            return IsSome ? f(value) : new Option<U>(false, default);
        }

        public Option<T> AndThen(Func<T, Option<T>> f)
        {
            return IsSome ? f(value) : this;
        }

        public Option<U> Map<U>(Func<T, U> f)
        {
            return IsSome
                ? new Option<U>(true, f(value))
                : new Option<U>(false, default);
        }

        public Option<T> Map(Func<T, T> f)
        {
            return IsSome ? new Option<T>(true, f(value)) : this;
        }
    }
}
