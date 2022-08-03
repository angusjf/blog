---
title: "How learning about Variance helped me fix a Pyright error"
img_url: images/elm.webp
img_alt: The Elm logo
date: "2021-10-25"
seo_description: "Fixing Dan and Aydın's Pyright Error"
summary: How Elm takes a novel approach to creating frontend applications, and what React developers can learn from it. Originally written for the [Theodo Blog](https://blog.theodo.com/2021/10/intro-to-elm-for-react-devs/), published in the [React Newsletter](https://reactnewsletter.com/issues/289).
tags: ["elm", "react", "functional", "javascript", "typescript"]
hidden: true
---
# Fixing Dan and Aydın's Pyright Error

## Backstory

A few months ago, my friends Dan and Aydın showed me this strange bug in the project they were working on.

They were using Python with type annotations and Microsoft's Pylance/Pyright type checker - here's the problematic snippet:

```py
TODO
```

When they ran the type checker on this code, they were presented with the following error:

```py
TODO
```

This is the compiler's way of saying *__"you can't pass a value of type `Dict[str, str]` into a function that expects `Dict[str, str | None]`"__*

This seems wrong - surely any function that can handle a `Dict[str, str | None]` can handle a `Dict[str, str]` - in fact, a `Dict[str, str]` *is* a `Dict[str, str | None]`!

Sure enough, we can check that a `str` is a `str | None`:

```py
name1: str = "guido"
name2: str | None = name1
```

Pyright has no problems at all with this code.

Surely (to be overly mathematical) if _`x` is a subtype of `y`_ then  _`Dict[a, x]` is a subtype of `Dict[a, y]`_.

Very puzzling...

## Rust for Rustaceans

Crushingly, I could never fix Dan and Aydın's type error. I just shrugged and said Microsoft probably never bothered to implement that rule.

Then, three months later, I was reading (the fantastic) _Rust for Rustaceans_ (a book about the Rust programming language). On page ** they mention the concept of variance, an idea I'd never heard of before.

It turns out **variance** was the culprit all along - but first, let me introduce it with a tour of some popular programming languages.

## Variance in TypeScript

TypeScript has never sold itself as a fully type-safe solution, more of a glorified linter.
It helps you catch **some** errors before you see them at runtime.

_Consider the following (valid & compilable) TypeScript program._

```ts
type Status = "OK" | "PENDING" | "INVALID"

type ValidStatus = "OK" | "PENDING"

const orders: ValidStatus[] = ["OK", "OK", "PENDING"]

const add = (orders: Status[]) => {
    orders.push("INVALID");
}

add(orders)
```

Now orders has an invalid order in it - but it's type (`ValidStatus[]`) would tell you that's impossible!

The issue here is that we are *mutating the list* inside the add function.

If we treat `orders` as a `Status[]` in one place, and refer to it as a `ValidStatus[]` in another, we can cause all kinds of problems.

This can be avoided with the following, **immutable** version of the `add` function:

```ts
todo
```

However:
- It's not ideomatic JavaScript
- It's far less efficient than using `push`

It's easy to get caught up evangilising immutable JavaScript as the solutions to these kinds of problems,
but the performance impact can't be understated (see footnote 1 for an example).

## Variance in Java

Java's type system is stronger than TypeScript's, so let's recreate a similar example and see how it fares:

```java
import java.util.List;

class Status {}

class ValidStatus extends Status {}

class Main {
    public static void main(String[] args) {
        List<ValidStatus> orders;
        
        add(orders);
    }
    
    static void add(List<Status> orders) {
        // ...
    }
}
```

Java gives the following error:

```

```

Pretty harsh! Java won't let us pass a `List<ValidStatus>` into a `List<Status>`, for fear we may mutate it.

I suppose that's one way of solving the problem?

## Variance in Rust

Rust's type system is the only one I've seen that **solves this problem properly**, that is to say it allows valid functions an d disallows dangerous ones.

```rs
let x: u32 = 1
```

To finally introduce the term, we can describe List

## Variance in Pyright

With all of this context, let's look back at our original problem:

```py

```

I finally see why Pyright is worried about this code.

How does it know we're not going to change the `***` dictionary inside the `***999*` function?

Here Pyright is being just as strict as Java (although a little more cyptic).


