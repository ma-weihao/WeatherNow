# Android 开发者 Kotlin 到 Swift 迁移指南

## 目录
1. [介绍](#介绍)
2. [语言基础](#语言基础)
3. [数据类型和变量](#数据类型和变量)
4. [控制流](#控制流)
5. [函数](#函数)
6. [类和对象](#类和对象)
7. [集合](#集合)
8. [错误处理](#错误处理)
9. [异步编程](#异步编程)
10. [UI 开发](#ui-开发)
11. [内存管理详解](#内存管理详解)
12. [常用模式和最佳实践](#常用模式和最佳实践)
13. [完整技术栈 Demo 示例](#完整技术栈-demo-示例)

## 介绍

本指南帮助 Android 开发者从 Kotlin 过渡到 Swift 进行 iOS 开发。Swift 和 Kotlin 有许多相似之处，使得过渡相对顺利。两种语言都是现代的、类型安全的，并支持函数式编程范式。

### 主要相似点
- 类型推断
- 可选类型/可空类型
- 闭包/Lambda 表达式
- 基于协议/接口的编程
- 扩展函数
- 泛型

### 主要差异
- Swift 使用 `let`/`var` vs Kotlin 的 `val`/`var`
- Swift 有可选类型 vs Kotlin 的可空类型
- 闭包和函数类型的不同语法
- Swift 使用协议 vs Kotlin 的接口
- 不同的集合类型和语法

## 语言基础

### 基本语法

**Kotlin:**
```kotlin
fun main() {
    println("Hello, World!")
}
```

**Swift:**
```swift
func main() {
    print("Hello, World!")
}
```

### 注释

**Kotlin:**
```kotlin
// 单行注释
/* 多行
   注释 */
```

**Swift:**
```swift
// 单行注释
/* 多行
   注释 */
```

## 数据类型和变量

### 变量声明

**Kotlin:**
```kotlin
val immutableVar = "不可更改"
var mutableVar = "可以更改"
val explicitType: String = "显式类型"
```

**Swift:**
```swift
let immutableVar = "不可更改"
var mutableVar = "可以更改"
let explicitType: String = "显式类型"
```

### 基本类型

| Kotlin | Swift | 描述 |
|--------|-------|------|
| `Int` | `Int` | 整数 |
| `Long` | `Int64` | 长整数 |
| `Float` | `Float` | 32位浮点数 |
| `Double` | `Double` | 64位浮点数 |
| `Boolean` | `Bool` | 布尔值 |
| `String` | `String` | 字符串 |
| `Char` | `Character` | 单个字符 |

### 可空类型 vs 可选类型

**Kotlin:**
```kotlin
var nullableString: String? = null
var nonNullString: String = "Hello"

// 安全调用操作符
val length = nullableString?.length

// Elvis 操作符
val safeLength = nullableString?.length ?: 0

// 非空断言
val forcedLength = nullableString!!.length
```

**Swift:**
```swift
var optionalString: String? = nil
var nonOptionalString: String = "Hello"

// 可选绑定
if let length = optionalString?.count {
    print("长度: \(length)")
}

// 空合并操作符
let safeLength = optionalString?.count ?? 0

// 强制解包
let forcedLength = optionalString!.count
```

### 类型别名

**Kotlin:**
```kotlin
typealias UserId = String
typealias Callback = (String) -> Unit
```

**Swift:**
```swift
typealias UserId = String
typealias Callback = (String) -> Void
```

## 控制流

### If 语句

**Kotlin:**
```kotlin
val x = 10
if (x > 5) {
    println("大于 5")
} else if (x == 5) {
    println("等于 5")
} else {
    println("小于 5")
}

// 表达式
val result = if (x > 5) "Greater" else "Less"
```

**Swift:**
```swift
let x = 10
if x > 5 {
    print("大于 5")
} else if x == 5 {
    print("等于 5")
} else {
    print("小于 5")
}

// 三元操作符
let result = x > 5 ? "Greater" : "Less"
```

### When vs Switch

**Kotlin:**
```kotlin
val day = "Monday"
when (day) {
    "Monday" -> println("一周开始")
    "Friday" -> println("一周结束")
    else -> println("周中")
}

// 表达式
val message = when (day) {
    "Monday" -> "一周开始"
    "Friday" -> "一周结束"
    else -> "周中"
}
```

**Swift:**
```swift
let day = "Monday"
switch day {
case "Monday":
    print("一周开始")
case "Friday":
    print("一周结束")
default:
    print("周中")
}

// 表达式 (Swift 5.9+)
let message = switch day {
case "Monday": "一周开始"
case "Friday": "一周结束"
default: "周中"
}
```

### 循环

**Kotlin:**
```kotlin
// For 循环
for (i in 1..10) {
    println(i)
}

// For each
val list = listOf(1, 2, 3, 4, 5)
for (item in list) {
    println(item)
}

// While 循环
var i = 0
while (i < 10) {
    println(i)
    i++
}
```

**Swift:**
```swift
// For 循环
for i in 1...10 {
    print(i)
}

// For each
let list = [1, 2, 3, 4, 5]
for item in list {
    print(item)
}

// While 循环
var i = 0
while i < 10 {
    print(i)
    i += 1
}
```

## 函数

### 函数声明

**Kotlin:**
```kotlin
fun greet(name: String): String {
    return "Hello, $name!"
}

// 单表达式
fun add(a: Int, b: Int) = a + b

// 默认参数
fun greetWithDefault(name: String = "World"): String {
    return "Hello, $name!"
}
```

**Swift:**
```swift
func greet(name: String) -> String {
    return "Hello, \(name)!"
}

// 单表达式
func add(a: Int, b: Int) -> Int {
    a + b
}

// 默认参数
func greetWithDefault(name: String = "World") -> String {
    return "Hello, \(name)!"
}
```

### 高阶函数

**Kotlin:**
```kotlin
fun processNumbers(numbers: List<Int>, processor: (Int) -> Int): List<Int> {
    return numbers.map(processor)
}

// 使用
val result = processNumbers(listOf(1, 2, 3)) { it * 2 }
```

**Swift:**
```swift
func processNumbers(numbers: [Int], processor: (Int) -> Int) -> [Int] {
    return numbers.map(processor)
}

// 使用
let result = processNumbers(numbers: [1, 2, 3]) { $0 * 2 }
```

### 闭包

**Kotlin:**
```kotlin
val numbers = listOf(1, 2, 3, 4, 5)
val filtered = numbers.filter { it > 3 }
val mapped = numbers.map { it * 2 }
val reduced = numbers.reduce { acc, item -> acc + item }
```

**Swift:**
```swift
let numbers = [1, 2, 3, 4, 5]
let filtered = numbers.filter { $0 > 3 }
let mapped = numbers.map { $0 * 2 }
let reduced = numbers.reduce(0) { $0 + $1 }
```

## 类和对象

### 类声明

**Kotlin:**
```kotlin
class Person(
    val name: String,
    var age: Int
) {
    fun greet() = "Hello, I'm $name"
    
    companion object {
        fun create(name: String, age: Int) = Person(name, age)
    }
}
```

**Swift:**
```swift
class Person {
    let name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    func greet() -> String {
        return "Hello, I'm \(name)"
    }
    
    static func create(name: String, age: Int) -> Person {
        return Person(name: name, age: age)
    }
}
```

### 继承

**Kotlin:**
```kotlin
open class Animal(val name: String) {
    open fun makeSound() = "Some sound"
}

class Dog(name: String) : Animal(name) {
    override fun makeSound() = "Woof!"
}
```

**Swift:**
```swift
class Animal {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func makeSound() -> String {
        return "Some sound"
    }
}

class Dog: Animal {
    override func makeSound() -> String {
        return "Woof!"
    }
}
```

### 接口 vs 协议

**Kotlin:**
```kotlin
interface Drawable {
    fun draw()
    val area: Double
}

class Circle(val radius: Double) : Drawable {
    override fun draw() = println("Drawing circle")
    override val area: Double get() = Math.PI * radius * radius
}
```

**Swift:**
```swift
protocol Drawable {
    func draw()
    var area: Double { get }
}

class Circle: Drawable {
    let radius: Double
    
    init(radius: Double) {
        self.radius = radius
    }
    
    func draw() {
        print("Drawing circle")
    }
    
    var area: Double {
        return Double.pi * radius * radius
    }
}
```

### 数据类 vs 结构体

**Kotlin:**
```kotlin
data class User(
    val id: Int,
    val name: String,
    val email: String
)
```

**Swift:**
```swift
struct User {
    let id: Int
    let name: String
    let email: String
}
```

## 集合

### 数组

**Kotlin:**
```kotlin
val array = arrayOf(1, 2, 3, 4, 5)
val list = listOf(1, 2, 3, 4, 5)
val mutableList = mutableListOf(1, 2, 3)

// 操作
val doubled = list.map { it * 2 }
val filtered = list.filter { it > 3 }
val sum = list.sum()
```

**Swift:**
```swift
let array = [1, 2, 3, 4, 5]
let doubled = array.map { $0 * 2 }
let filtered = array.filter { $0 > 3 }
let sum = array.reduce(0, +)
```

### 字典

**Kotlin:**
```kotlin
val map = mapOf("key1" to "value1", "key2" to "value2")
val mutableMap = mutableMapOf<String, String>()

// 访问
val value = map["key1"]
val safeValue = map["key1"] ?: "default"
```

**Swift:**
```swift
let dictionary = ["key1": "value1", "key2": "value2"]
var mutableDictionary = [String: String]()

// 访问
let value = dictionary["key1"]
let safeValue = dictionary["key1"] ?? "default"
```

### 集合

**Kotlin:**
```kotlin
val set = setOf(1, 2, 3, 4, 5)
val mutableSet = mutableSetOf<Int>()
```

**Swift:**
```swift
let set: Set<Int> = [1, 2, 3, 4, 5]
var mutableSet = Set<Int>()
```

## 错误处理

### Try-Catch

**Kotlin:**
```kotlin
fun riskyOperation(): String {
    return try {
        // 一些有风险的代码
        "Success"
    } catch (e: Exception) {
        "Error: ${e.message}"
    }
}

// 或者使用 Result
fun riskyOperationWithResult(): Result<String> {
    return try {
        Result.success("Success")
    } catch (e: Exception) {
        Result.failure(e)
    }
}
```

**Swift:**
```swift
func riskyOperation() -> String {
    do {
        // 一些有风险的代码
        return "Success"
    } catch {
        return "Error: \(error.localizedDescription)"
    }
}

// 或者使用 Result
func riskyOperationWithResult() -> Result<String, Error> {
    do {
        // 一些有风险的代码
        return .success("Success")
    } catch {
        return .failure(error)
    }
}
```

### 自定义错误

**Kotlin:**
```kotlin
sealed class NetworkError : Exception() {
    object NoConnection : NetworkError()
    object Timeout : NetworkError()
    data class ServerError(val code: Int) : NetworkError()
}
```

**Swift:**
```swift
enum NetworkError: Error {
    case noConnection
    case timeout
    case serverError(code: Int)
}
```

## 异步编程

### 协程 vs Async/Await

**Kotlin:**
```kotlin
suspend fun fetchData(): String {
    delay(1000) // 模拟网络调用
    return "Data from network"
}

// 使用
lifecycleScope.launch {
    val data = fetchData()
    println(data)
}
```

**Swift:**
```swift
func fetchData() async -> String {
    try await Task.sleep(nanoseconds: 1_000_000_000) // 模拟网络调用
    return "Data from network"
}

// 使用
Task {
    let data = await fetchData()
    print(data)
}
```

### 带错误处理的异步函数

**Kotlin:**
```kotlin
suspend fun fetchUser(id: Int): Result<User> {
    return try {
        val user = apiService.getUser(id)
        Result.success(user)
    } catch (e: Exception) {
        Result.failure(e)
    }
}
```

**Swift:**
```swift
func fetchUser(id: Int) async throws -> User {
    return try await apiService.getUser(id: id)
}
```

## UI 开发

### 现代 UI 框架对比

#### Jetpack Compose vs SwiftUI





#### Jetpack Compose vs SwiftUI

**Kotlin (Jetpack Compose):**
```kotlin
@Composable
fun MainScreen() {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp)
    ) {
        Text(
            text = "Hello, World!",
            style = MaterialTheme.typography.h4
        )
        
        Button(
            onClick = { /* 处理点击 */ }
        ) {
            Text("点击我")
        }
    }
}
```

**Swift (SwiftUI):**
```swift
struct MainScreen: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Hello, World!")
                .font(.title)
            
            Button("点击我") {
                // 处理点击
            }
        }
        .padding()
    }
}
```

### 状态管理比较

#### Android 状态管理

**Kotlin (ViewModel + StateFlow):**
```kotlin
class MainViewModel : ViewModel() {
    private val _data = MutableStateFlow("")
    val data: StateFlow<String> = _data.asStateFlow()
    
    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading.asStateFlow()
    
    fun updateData(newData: String) {
        _data.value = newData
    }
    
    fun loadData() {
        _isLoading.value = true
        viewModelScope.launch {
            try {
                val result = repository.getData()
                _data.value = result
            } finally {
                _isLoading.value = false
            }
        }
    }
}
```

**Kotlin (Jetpack Compose State):**
```kotlin
@Composable
fun MainScreen() {
    var data by remember { mutableStateOf("") }
    var isLoading by remember { mutableStateOf(false) }
    
    LaunchedEffect(Unit) {
        isLoading = true
        try {
            data = repository.getData()
        } finally {
            isLoading = false
        }
    }
    
    Column {
        if (isLoading) {
            CircularProgressIndicator()
        } else {
            Text(data)
        }
    }
}
```

#### iOS 状态管理

**Swift (ObservableObject):**
```swift
class MainViewModel: ObservableObject {
    @Published var data: String = ""
    @Published var isLoading: Bool = false
    
    func updateData(newData: String) {
        data = newData
    }
    
    func loadData() {
        isLoading = true
        Task {
            do {
                let result = try await repository.getData()
                await MainActor.run {
                    data = result
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                }
            }
        }
    }
}
```

**Swift (SwiftUI State):**
```swift
struct MainScreen: View {
    @State private var data: String = ""
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                Text(data)
            }
        }
        .task {
            isLoading = true
            do {
                data = try await repository.getData()
            } catch {
                // 处理错误
            }
            isLoading = false
        }
    }
}
```











### 列表组件

#### Jetpack Compose 列表

**Kotlin (Jetpack Compose LazyColumn):**
```kotlin
@Composable
fun ListExample() {
    val items = listOf("项目 1", "项目 2", "项目 3", "项目 4", "项目 5")
    
    LazyColumn {
        items(items) { item ->
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(8.dp)
            ) {
                Text(
                    text = item,
                    modifier = Modifier.padding(16.dp)
                )
            }
        }
    }
}
```



#### SwiftUI 列表

**Swift (SwiftUI List):**
```swift
struct ListExample: View {
    let items = ["项目 1", "项目 2", "项目 3", "项目 4", "项目 5"]
    
    var body: some View {
        List(items, id: \.self) { item in
            HStack {
                Text(item)
                Spacer()
            }
            .padding()
        }
    }
}
```





### 迁移策略

#### 从 Jetpack Compose 到 SwiftUI

1. **布局迁移:**
   - Column → VStack
   - Row → HStack
   - Box → ZStack
   - LazyColumn → List/LazyVStack

2. **组件迁移:**
   - Text → Text
   - TextField → TextField
   - Button → Button
   - Image → Image
   - Card → 自定义卡片组件

3. **状态管理:**
   - ViewModel + StateFlow → ObservableObject + @Published
   - remember → @State, @StateObject
   - mutableStateOf → @State



### 性能考虑

#### Android 性能
- **Jetpack Compose:** Compose 编译器优化，重组作用域
- **内存管理:** 垃圾回收，内存泄漏预防

#### iOS 性能
- **SwiftUI:** 视图更新，状态管理效率
- **内存管理:** ARC (自动引用计数)

## 内存管理详解

### 核心机制对比

Kotlin 和 Swift 在内存管理方面采用完全不同的机制，这是迁移过程中需要重点理解的概念。

#### Kotlin (JVM) - 垃圾回收 (GC)
- **机制:** 自动垃圾回收器在后台运行
- **特点:** 开发者无需手动管理内存
- **时机:** GC 在适当时机自动回收不再使用的对象
- **影响:** 可能造成短暂停顿，内存释放时机不确定

#### Swift (iOS/macOS) - 自动引用计数 (ARC)
- **机制:** 编译器在编译时插入内存管理代码
- **特点:** 基于引用计数，当计数为 0 时立即释放
- **时机:** 引用计数降为 0 时立即释放内存
- **影响:** 无 GC 停顿，内存释放更可预测

### 引用计数机制详解

#### Kotlin 引用管理
```kotlin
class User {
    var name: String = ""
}

fun example() {
    val user1 = User() // 对象创建，GC 管理
    val user2 = user1  // 引用复制，GC 跟踪
    
    // 当 user1 和 user2 都超出作用域时，GC 会回收对象
    // 但回收时机不确定，可能在几分钟后或下次 GC 时
}
```

#### Swift 引用计数
```swift
class User {
    var name: String = ""
}

func example() {
    let user1 = User() // 引用计数 = 1
    let user2 = user1  // 引用计数 = 2
    
    // 当 user2 超出作用域时，引用计数 = 1
    // 当 user1 超出作用域时，引用计数 = 0，立即释放
}
```

### 循环引用处理

#### Kotlin 循环引用
```kotlin
class Parent {
    var child: Child? = null
}

class Child {
    var parent: Parent? = null
}

fun createCycle() {
    val parent = Parent()
    val child = Child()
    
    parent.child = child
    child.parent = parent
    
    // GC 会检测并处理循环引用
    // 但可能需要多次 GC 周期才能完全清理
}
```

#### Swift 循环引用解决方案
```swift
class Parent {
    var child: Child?
}

class Child {
    weak var parent: Parent? // 使用 weak 避免循环引用
}

func createCycle() {
    let parent = Parent()
    let child = Child()
    
    parent.child = child
    child.parent = parent
    
    // 使用 weak 引用，不会造成循环引用
    // 当 parent 释放时，child.parent 自动变为 nil
}
```

### 常见内存泄漏场景

#### Kotlin 内存泄漏
```kotlin
class MyActivity : AppCompatActivity() {
    private val handler = Handler()
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // 潜在泄漏：匿名内部类持有 Activity 引用
        handler.postDelayed({
            // 这里持有 Activity 的隐式引用
            updateUI()
        }, 5000)
    }
    
    private fun updateUI() {
        // 即使 Activity 被销毁，这个回调仍可能执行
    }
    
    override fun onDestroy() {
        super.onDestroy()
        handler.removeCallbacksAndMessages(null) // 清理回调
    }
}
```

#### Swift 内存泄漏
```swift
class MyViewController: UIViewController {
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 潜在泄漏：Timer 持有 ViewController 的强引用
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateUI() // 强引用循环
        }
    }
    
    private func updateUI() {
        // 即使 ViewController 被销毁，Timer 仍会继续运行
    }
    
    deinit {
        timer?.invalidate() // 需要在 deinit 中清理
    }
}
```

### 性能特征对比

| 特性 | Kotlin (GC) | Swift (ARC) |
|------|-------------|-------------|
| **内存释放时机** | 不确定，GC 决定 | 立即，引用计数为 0 时 |
| **性能影响** | 可能有 GC 停顿 | 无停顿，但引用计数开销 |
| **内存使用** | 可能使用更多内存 | 更精确的内存使用 |
| **可预测性** | 较低 | 较高 |
| **调试难度** | 较难调试内存问题 | 相对容易调试 |

### 最佳实践对比

#### Kotlin 内存管理最佳实践
```kotlin
class MyViewModel : ViewModel() {
    private val _data = MutableStateFlow("")
    val data: StateFlow<String> = _data.asStateFlow()
    
    // 使用 ViewModel 避免 Activity 泄漏
    fun loadData() {
        viewModelScope.launch {
            // 协程作用域自动管理
            val result = repository.getData()
            _data.value = result
        }
    }
    
    // 使用 WeakReference 避免循环引用
    private val callback = WeakReference<Callback>(callback)
}
```

#### Swift 内存管理最佳实践
```swift
class MyViewModel: ObservableObject {
    @Published var data: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    func loadData() {
        // 使用 Combine 的自动取消
        repository.getData()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.data = result
            }
            .store(in: &cancellables)
    }
    
    // 使用 weak self 避免闭包循环引用
    func setupTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateData()
        }
    }
}
```

### 调试工具对比

#### Kotlin 调试工具
- **Android Studio Memory Profiler:** 实时内存使用分析
- **LeakCanary:** 自动检测内存泄漏
- **GC 日志分析:** 分析垃圾回收行为
- **Heap Dump 分析:** 详细内存快照分析

#### Swift 调试工具
- **Xcode Instruments (Leaks):** 检测内存泄漏
- **Xcode Instruments (Allocations):** 内存分配分析
- **内存图调试器:** 可视化对象关系
- **ARC 调试选项:** 编译时内存管理分析

### 迁移注意事项

从 Kotlin 迁移到 Swift 时，内存管理方面需要特别注意：

1. **理解 ARC 机制:** 不再依赖 GC，需要主动管理引用关系
2. **使用 weak/unowned:** 避免循环引用，特别是在闭包中
3. **及时清理资源:** 在 `deinit` 中清理定时器、通知、观察者等
4. **注意闭包捕获:** 使用 `[weak self]` 避免强引用循环
5. **利用值类型:** 优先使用 `struct` 和 `enum`，它们不参与引用计数
6. **理解所有权:** 掌握 `strong`、`weak`、`unowned` 的区别和使用场景





## 常用模式和最佳实践

### 单例模式

**Kotlin:**
```kotlin
object NetworkManager {
    fun makeRequest() {
        // 实现
    }
}
```

**Swift:**
```swift
class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func makeRequest() {
        // 实现
    }
}
```

### 建造者模式

**Kotlin:**
```kotlin
class UserBuilder {
    private var name: String = ""
    private var age: Int = 0
    
    fun name(name: String) = apply { this.name = name }
    fun age(age: Int) = apply { this.age = age }
    fun build() = User(name, age)
}
```

**Swift:**
```swift
class UserBuilder {
    private var name: String = ""
    private var age: Int = 0
    
    func name(_ name: String) -> UserBuilder {
        self.name = name
        return self
    }
    
    func age(_ age: Int) -> UserBuilder {
        self.age = age
        return self
    }
    
    func build() -> User {
        return User(name: name, age: age)
    }
}
```

### 依赖注入

**Kotlin:**
```kotlin
class UserService(private val apiClient: ApiClient) {
    fun getUser(id: Int) = apiClient.getUser(id)
}
```

**Swift:**
```swift
class UserService {
    private let apiClient: ApiClient
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    func getUser(id: Int) async throws -> User {
        return try await apiClient.getUser(id: id)
    }
}
```

## 完整技术栈 Demo 示例

下面是一个完整的数据展示应用示例，展示了 Kotlin 和 Swift 的核心开发模式对比。

### 数据模型

**Kotlin:**
```kotlin
data class Item(
    val id: String = UUID.randomUUID().toString(),
    val title: String,
    val description: String,
    val isCompleted: Boolean = false
)
```

**Swift:**
```swift
struct Item: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    var isCompleted: Bool
    
    init(id: String = UUID().uuidString, title: String, description: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
    }
}
```

### 数据存储

**Kotlin (DataStore):**
```kotlin
class DataStoreManager(private val context: Context) {
    private val Context.dataStore: DataStore<String> by preferencesDataStore(name = "items")
    
    suspend fun saveItems(items: List<Item>) {
        context.dataStore.edit { preferences ->
            val json = Json.encodeToString(items)
            preferences[PreferencesKeys.ITEMS] = json
        }
    }
    
    suspend fun loadItems(): List<Item> {
        val json = context.dataStore.data.first()[PreferencesKeys.ITEMS] ?: "[]"
        return Json.decodeFromString(json)
    }
    
    private object PreferencesKeys {
        val ITEMS = stringPreferencesKey("items")
    }
}
```

**Swift (UserDefaults):**
```swift
class DataStoreManager {
    static let shared = DataStoreManager()
    private let defaults = UserDefaults.standard
    private let itemsKey = "items"
    
    private init() {}
    
    func saveItems(_ items: [Item]) {
        if let encoded = try? JSONEncoder().encode(items) {
            defaults.set(encoded, forKey: itemsKey)
        }
    }
    
    func loadItems() -> [Item] {
        guard let data = defaults.data(forKey: itemsKey),
              let items = try? JSONDecoder().decode([Item].self, from: data) else {
            return []
        }
        return items
    }
}
```

### ViewModel / ObservableObject

**Kotlin (ViewModel + StateFlow):**
```kotlin
class ItemViewModel(
    private val dataStore: DataStoreManager
) : ViewModel() {
    
    private val _items = MutableStateFlow<List<Item>>(emptyList())
    val items: StateFlow<List<Item>> = _items.asStateFlow()
    
    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading.asStateFlow()
    
    init {
        loadItems()
    }
    
    fun addItem(title: String, description: String) {
        val newItem = Item(title = title, description = description)
        val currentItems = _items.value.toMutableList()
        currentItems.add(newItem)
        _items.value = currentItems
        saveItems()
    }
    
    fun toggleItem(id: String) {
        val currentItems = _items.value.map { item ->
            if (item.id == id) item.copy(isCompleted = !item.isCompleted) else item
        }
        _items.value = currentItems
        saveItems()
    }
    
    fun deleteItem(id: String) {
        val currentItems = _items.value.filter { it.id != id }
        _items.value = currentItems
        saveItems()
    }
    
    private fun loadItems() {
        viewModelScope.launch {
            _isLoading.value = true
            try {
                val items = dataStore.loadItems()
                _items.value = items
            } catch (e: Exception) {
                // 处理错误
            } finally {
                _isLoading.value = false
            }
        }
    }
    
    private fun saveItems() {
        viewModelScope.launch {
            try {
                dataStore.saveItems(_items.value)
            } catch (e: Exception) {
                // 处理错误
            }
        }
    }
}
```

**Swift (ObservableObject + Combine):**
```swift
@MainActor
class ItemViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var isLoading: Bool = false
    
    private let dataStore = DataStoreManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadItems()
    }
    
    func addItem(title: String, description: String) {
        let newItem = Item(title: title, description: description)
        items.append(newItem)
        saveItems()
    }
    
    func toggleItem(id: String) {
        if let index = items.firstIndex(where: { $0.id == id }) {
            items[index].isCompleted.toggle()
            saveItems()
        }
    }
    
    func deleteItem(id: String) {
        items.removeAll { $0.id == id }
        saveItems()
    }
    
    private func loadItems() {
        isLoading = true
        items = dataStore.loadItems()
        isLoading = false
    }
    
    private func saveItems() {
        dataStore.saveItems(items)
    }
}
```

### UI 层

**Kotlin (Jetpack Compose):**
```kotlin
@Composable
fun ItemListScreen(
    viewModel: ItemViewModel = viewModel()
) {
    val items by viewModel.items.collectAsState()
    val isLoading by viewModel.isLoading.collectAsState()
    var showAddDialog by remember { mutableStateOf(false) }
    var newTitle by remember { mutableStateOf("") }
    var newDescription by remember { mutableStateOf("") }
    
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp)
    ) {
        // 标题
        Text(
            text = "数据列表",
            style = MaterialTheme.typography.h4,
            modifier = Modifier.padding(bottom = 16.dp)
        )
        
        // 添加按钮
        Button(
            onClick = { showAddDialog = true },
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("添加项目")
        }
        
        Spacer(modifier = Modifier.height(16.dp))
        
        // 列表
        if (isLoading) {
            CircularProgressIndicator(
                modifier = Modifier.align(Alignment.CenterHorizontally)
            )
        } else {
            LazyColumn {
                items(items) { item ->
                    ItemCard(
                        item = item,
                        onToggle = { viewModel.toggleItem(item.id) },
                        onDelete = { viewModel.deleteItem(item.id) }
                    )
                }
            }
        }
    }
    
    // 添加对话框
    if (showAddDialog) {
        AlertDialog(
            onDismissRequest = { showAddDialog = false },
            title = { Text("添加新项目") },
            text = {
                Column {
                    TextField(
                        value = newTitle,
                        onValueChange = { newTitle = it },
                        label = { Text("标题") }
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    TextField(
                        value = newDescription,
                        onValueChange = { newDescription = it },
                        label = { Text("描述") }
                    )
                }
            },
            confirmButton = {
                Button(
                    onClick = {
                        if (newTitle.isNotBlank()) {
                            viewModel.addItem(newTitle, newDescription)
                            newTitle = ""
                            newDescription = ""
                            showAddDialog = false
                        }
                    }
                ) {
                    Text("添加")
                }
            },
            dismissButton = {
                Button(onClick = { showAddDialog = false }) {
                    Text("取消")
                }
            }
        )
    }
}

@Composable
fun ItemCard(
    item: Item,
    onToggle: () -> Unit,
    onDelete: () -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 4.dp),
        elevation = 4.dp
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Checkbox(
                checked = item.isCompleted,
                onCheckedChange = { onToggle() }
            )
            
            Column(
                modifier = Modifier.weight(1f)
            ) {
                Text(
                    text = item.title,
                    style = MaterialTheme.typography.h6,
                    textDecoration = if (item.isCompleted) TextDecoration.LineThrough else null
                )
                Text(
                    text = item.description,
                    style = MaterialTheme.typography.body2,
                    color = MaterialTheme.colors.onSurface.copy(alpha = 0.6f)
                )
            }
            
            IconButton(onClick = onDelete) {
                Icon(Icons.Default.Delete, contentDescription = "删除")
            }
        }
    }
}
```

**Swift (SwiftUI):**
```swift
struct ItemListScreen: View {
    @StateObject private var viewModel = ItemViewModel()
    @State private var showAddSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.items) { item in
                            ItemCard(
                                item: item,
                                onToggle: { viewModel.toggleItem(item.id) },
                                onDelete: { viewModel.deleteItem(item.id) }
                            )
                        }
                    }
                }
            }
            .navigationTitle("数据列表")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("添加") {
                        showAddSheet = true
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddItemSheet(viewModel: viewModel)
            }
        }
    }
}

struct ItemCard: View {
    let item: Item
    let onToggle: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(item.isCompleted ? .green : .gray)
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                    .strikethrough(item.isCompleted)
                
                Text(item.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 4)
    }
}

struct AddItemSheet: View {
    @ObservedObject var viewModel: ItemViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var title = ""
    @State private var description = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("项目信息")) {
                    TextField("标题", text: $title)
                    TextField("描述", text: $description)
                }
            }
            .navigationTitle("添加项目")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("添加") {
                        if !title.isEmpty {
                            viewModel.addItem(title: title, description: description)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}
```

### 应用入口

**Kotlin (MainActivity):**
```kotlin
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MaterialTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colors.background
                ) {
                    ItemListScreen()
                }
            }
        }
    }
}
```

**Swift (App):**
```swift
@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            ItemListScreen()
        }
    }
}
```

### 技术栈对比总结

| 技术 | Kotlin | Swift |
|------|--------|-------|
| **UI 框架** | Jetpack Compose | SwiftUI |
| **状态管理** | ViewModel + StateFlow | ObservableObject + @Published |
| **数据持久化** | DataStore | UserDefaults |
| **架构模式** | MVVM | MVVM |
| **响应式编程** | Kotlin Flow | Combine |
| **依赖注入** | Hilt (可选) | 手动注入 |
| **异步处理** | Coroutines | async/await |

这个示例展示了两种语言在相同功能下的不同实现方式，涵盖了现代移动应用开发的核心技术栈。

### 资源
- [Swift 文档](https://docs.swift.org/swift-book/)
- [Apple 开发者文档](https://developer.apple.com/documentation/)
- [SwiftUI 教程](https://developer.apple.com/tutorials/swiftui)
- [iOS 人机界面指南](https://developer.apple.com/design/human-interface-guidelines/)

---

*本指南为从 Kotlin 迁移到 Swift 提供了基础。请记住，两种语言都在不断发展，因此请始终参考最新文档以获取最新信息。*
