# z language
This is a toy language. It is written in swift.
Its backend is swift. Z compiles code into swift code directly.

# Build a compiler
First you need to install swift language.
```bash
git clone https://github.com/luoheng23/z
cd z
swift build
```
Now you get a z compiler!
# hello world
```
fn main() {
    println('Hello world!')
}

mainn()
```
# run the code
```bash
z hello.z
```
Or build it
```bash
z build hello.z
```

## TODO
* type check
* standard library