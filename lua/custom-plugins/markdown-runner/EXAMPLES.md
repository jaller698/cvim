```python
print("hejsa")
print ("echo test 3")
age = 20
if age >= 18:
    print("Eligible to vote.")
```
```fish
>> hejsa
>> echo test 3
>> Eligible to vote.
```

```c
#include <stdio.h>

int main() {
    printf("Hello world\n");
    return -2;
}
```
```fish
>> Hello world
>> Return code: 254
```

```c++
#include <iostream>

int square(int num) {
    return num * num;
}

int main() {
    std::cout << "num: " << square(9) << std::endl;

    return square(5);

}
```
```fish
>> num: 81
>> Return code: 25
```

```rust
pub fn main() {
    println!("hello world");
}
```
```fish
>> hello world
>> Return code: 0
```

```javascript
console.log("test")
```
```fish
>> test
```

```dart
void main() {
  for (var i = 0; i < 5; i++) {
    print('hello ${i + 1}');
  }
}
```
```fish
>> hello 1
>> hello 2
>> hello 3
>> hello 4
>> hello 5
```

```elixir
"Elixir" |> String.graphemes() |> Enum.frequencies()

```
```fish
>> Erlang/OTP 28 [erts-16.0.2] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [jit:ns]
>> Interactive Elixir (1.18.4) - press Ctrl+C to exit (type h() ENTER for help)
>> iex(1)> %{"E" => 1, "i" => 2, "l" => 1, "r" => 1, "x" => 1}
```

```go
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}
```
```fish
>> Hello, World!
>> Return code: 0
```

This text should not be removed

