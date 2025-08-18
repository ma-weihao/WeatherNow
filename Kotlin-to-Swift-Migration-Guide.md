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
11. [常用模式和最佳实践](#常用模式和最佳实践)
12. [迁移检查清单](#迁移检查清单)

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

### 传统视图 vs 现代 UI 框架

#### Android Views vs UIKit

**Kotlin (Android Views):**
```kotlin
class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        
        val textView = findViewById<TextView>(R.id.textView)
        textView.text = "Hello, World!"
    }
}
```

**Swift (UIKit):**
```swift
class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        label.text = "Hello, World!"
        view.addSubview(label)
    }
}
```

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

**Kotlin (ViewModel + LiveData):**
```kotlin
class MainViewModel : ViewModel() {
    private val _data = MutableLiveData<String>()
    val data: LiveData<String> = _data
    
    private val _isLoading = MutableLiveData<Boolean>()
    val isLoading: LiveData<Boolean> = _isLoading
    
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

### 导航模式

#### Android 导航

**Kotlin (Jetpack Compose Navigation):**
```kotlin
@Composable
fun AppNavigation() {
    val navController = rememberNavController()
    
    NavHost(navController = navController, startDestination = "home") {
        composable("home") {
            HomeScreen(navController)
        }
        composable("detail/{id}") { backStackEntry ->
            val id = backStackEntry.arguments?.getString("id")
            DetailScreen(id = id)
        }
    }
}

@Composable
fun HomeScreen(navController: NavController) {
    Button(
        onClick = { navController.navigate("detail/123") }
    ) {
        Text("前往详情")
    }
}
```

**Kotlin (传统导航):**
```kotlin
class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        
        findViewById<Button>(R.id.button).setOnClickListener {
            val intent = Intent(this, DetailActivity::class.java)
            intent.putExtra("id", "123")
            startActivity(intent)
        }
    }
}
```

#### iOS 导航

**Swift (SwiftUI Navigation):**
```swift
struct AppNavigation: View {
    var body: some View {
        NavigationView {
            NavigationLink("前往详情", destination: DetailScreen(id: "123"))
                .navigationTitle("首页")
        }
    }
}

struct DetailScreen: View {
    let id: String
    
    var body: some View {
        Text("详情页面 \(id)")
            .navigationTitle("详情")
    }
}
```

**Swift (UIKit Navigation):**
```swift
class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton()
        button.setTitle("前往详情", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func buttonTapped() {
        let detailVC = DetailViewController()
        detailVC.id = "123"
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
```

### 布局系统

#### Android 布局

**Kotlin (Jetpack Compose):**
```kotlin
@Composable
fun LayoutExample() {
    Column(
        modifier = Modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Box(
            modifier = Modifier
                .weight(1f)
                .fillMaxWidth()
                .background(Color.Blue)
        ) {
            Text("顶部区域")
        }
        
        Row(
            modifier = Modifier
                .weight(1f)
                .fillMaxWidth()
        ) {
            Box(
                modifier = Modifier
                    .weight(1f)
                    .fillMaxHeight()
                    .background(Color.Green)
            ) {
                Text("左侧")
            }
            
            Box(
                modifier = Modifier
                    .weight(1f)
                    .fillMaxHeight()
                    .background(Color.Red)
            ) {
                Text("右侧")
            }
        }
    }
}
```

**Kotlin (XML Layout):**
```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical">

    <TextView
        android:layout_width="match_parent"
        android:layout_height="0dp"
        android:layout_weight="1"
        android:background="#0000FF"
        android:text="顶部区域" />

    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="0dp"
        android:layout_weight="1"
        android:orientation="horizontal">

        <TextView
            android:layout_width="0dp"
            android:layout_height="match_parent"
            android:layout_weight="1"
            android:background="#00FF00"
            android:text="左侧" />

        <TextView
            android:layout_width="0dp"
            android:layout_height="match_parent"
            android:layout_weight="1"
            android:background="#FF0000"
            android:text="右侧" />

    </LinearLayout>
</LinearLayout>
```

#### iOS 布局

**Swift (SwiftUI):**
```swift
struct LayoutExample: View {
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.blue)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(Text("顶部区域"))
            
            HStack(spacing: 0) {
                Rectangle()
                    .fill(Color.green)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(Text("左侧"))
                
                Rectangle()
                    .fill(Color.red)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(Text("右侧"))
            }
        }
    }
}
```

**Swift (Auto Layout):**
```swift
class LayoutViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topView = UIView()
        topView.backgroundColor = .blue
        topView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topView)
        
        let leftView = UIView()
        leftView.backgroundColor = .green
        leftView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(leftView)
        
        let rightView = UIView()
        rightView.backgroundColor = .red
        rightView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rightView)
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            leftView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            leftView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            leftView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            leftView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            rightView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            rightView.leadingAnchor.constraint(equalTo: leftView.trailingAnchor),
            rightView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rightView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
```

### 数据绑定

#### Android 数据绑定

**Kotlin (Jetpack Compose):**
```kotlin
@Composable
fun DataBindingExample() {
    var text by remember { mutableStateOf("") }
    
    Column {
        TextField(
            value = text,
            onValueChange = { text = it },
            label = { Text("输入文本") }
        )
        
        Text("你输入了: $text")
    }
}
```

**Kotlin (Data Binding with XML):**
```xml
<layout xmlns:android="http://schemas.android.com/apk/res/android">
    <data>
        <variable name="viewModel" type="com.example.MainViewModel" />
    </data>
    
    <LinearLayout android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:orientation="vertical">
        
        <EditText
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:text="@={viewModel.text}" />
        
        <TextView
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:text="@{viewModel.text}" />
    </LinearLayout>
</layout>
```

#### iOS 数据绑定

**Swift (SwiftUI):**
```swift
struct DataBindingExample: View {
    @State private var text: String = ""
    
    var body: some View {
        VStack {
            TextField("输入文本", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Text("你输入了: \(text)")
        }
        .padding()
    }
}
```

### 列表和 RecyclerView

#### Android 列表

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

**Kotlin (RecyclerView):**
```kotlin
class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        
        val recyclerView = findViewById<RecyclerView>(R.id.recyclerView)
        recyclerView.layoutManager = LinearLayoutManager(this)
        recyclerView.adapter = MyAdapter(listOf("项目 1", "项目 2", "项目 3"))
    }
}

class MyAdapter(private val items: List<String>) : 
    RecyclerView.Adapter<MyAdapter.ViewHolder>() {
    
    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val textView: TextView = view.findViewById(R.id.textView)
    }
    
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_layout, parent, false)
        return ViewHolder(view)
    }
    
    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        holder.textView.text = items[position]
    }
    
    override fun getItemCount() = items.size
}
```

#### iOS 列表

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

**Swift (UITableView):**
```swift
class MainViewController: UIViewController, UITableViewDataSource {
    let items = ["项目 1", "项目 2", "项目 3", "项目 4", "项目 5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        
        // 设置约束...
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}
```

### 平台特定考虑

#### Android 平台特性

**Kotlin (权限):**
```kotlin
class MainActivity : AppCompatActivity() {
    private val PERMISSION_REQUEST_CODE = 123
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        
        if (checkSelfPermission(Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(arrayOf(Manifest.permission.CAMERA), PERMISSION_REQUEST_CODE)
        }
    }
    
    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == PERMISSION_REQUEST_CODE) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // 权限已授予
            }
        }
    }
}
```

**Kotlin (SharedPreferences):**
```kotlin
class SettingsManager(context: Context) {
    private val prefs = context.getSharedPreferences("app_settings", Context.MODE_PRIVATE)
    
    fun saveString(key: String, value: String) {
        prefs.edit().putString(key, value).apply()
    }
    
    fun getString(key: String, defaultValue: String): String {
        return prefs.getString(key, defaultValue) ?: defaultValue
    }
}
```

#### iOS 平台特性

**Swift (权限):**
```swift
import AVFoundation

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    // 权限已授予
                } else {
                    // 权限被拒绝
                }
            }
        }
    }
}
```

**Swift (UserDefaults):**
```swift
class SettingsManager {
    static let shared = SettingsManager()
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    func saveString(_ value: String, forKey key: String) {
        defaults.set(value, forKey: key)
    }
    
    func getString(forKey key: String, defaultValue: String) -> String {
        return defaults.string(forKey: key) ?? defaultValue
    }
}
```

### 迁移策略

#### 从 Android Views 到 SwiftUI

1. **布局迁移:**
   - LinearLayout → VStack/HStack
   - RelativeLayout → ZStack with positioning
   - ConstraintLayout → SwiftUI 的灵活布局系统

2. **组件迁移:**
   - TextView → Text
   - EditText → TextField
   - Button → Button
   - ImageView → Image
   - RecyclerView → List/LazyVStack

3. **状态管理:**
   - ViewModel + LiveData → ObservableObject + @Published
   - Data Binding → @State, @Binding, @StateObject

#### 从 Jetpack Compose 到 SwiftUI

1. **可组合函数:**
   - @Composable → View protocol
   - remember → @State, @StateObject
   - mutableStateOf → @State

2. **布局迁移:**
   - Column → VStack
   - Row → HStack
   - Box → ZStack
   - LazyColumn → List/LazyVStack

3. **状态提升:**
   - 两个框架中的相似模式
   - 状态管理概念转换良好

### 性能考虑

#### Android 性能
- **Jetpack Compose:** Compose 编译器优化，重组作用域
- **传统视图:** 视图回收，视图持有者模式
- **内存管理:** 垃圾回收，内存泄漏预防

#### iOS 性能
- **SwiftUI:** 视图更新，状态管理效率
- **UIKit:** 单元格重用，视图层次优化
- **内存管理:** ARC (自动引用计数)

### 测试方法

#### Android 测试
```kotlin
@RunWith(AndroidJUnit4::class)
class MainActivityTest {
    @get:Rule
    val composeTestRule = createComposeRule()
    
    @Test
    fun testButtonClick() {
        composeTestRule.setContent {
            MainScreen()
        }
        
        composeTestRule.onNodeWithText("点击我").performClick()
        composeTestRule.onNodeWithText("按钮已点击").assertIsDisplayed()
    }
}
```

#### iOS 测试
```swift
import XCTest
@testable import YourApp

class MainViewTests: XCTestCase {
    func testButtonClick() throws {
        let view = MainView()
        let button = view.button
        
        button.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(view.label.text, "按钮已点击")
    }
}
```

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

## 迁移检查清单

### 迁移前
- [ ] 分析现有 Kotlin 代码库
- [ ] 识别平台特定依赖
- [ ] 规划 iOS 架构
- [ ] 设置 iOS 开发环境
- [ ] 在 UIKit 和 SwiftUI 之间选择

### 迁移过程中
- [ ] 转换数据模型 (数据类 → 结构体)
- [ ] 迁移业务逻辑
- [ ] 适配网络层
- [ ] 转换 UI 组件
- [ ] 更新错误处理
- [ ] 迁移异步操作

### 迁移后
- [ ] 测试所有功能
- [ ] 优化性能
- [ ] 审查 iOS 特定模式
- [ ] 更新文档
- [ ] 进行代码审查

### 需要避免的常见陷阱
1. **忘记可选类型**: 始终正确处理可选值
2. **忽略内存管理**: 理解 ARC vs 垃圾回收
3. **直接语法翻译**: 适应 Swift 惯用法
4. **平台特定功能**: 不要尝试复制 Android 特定功能
5. **UI 模式**: 理解 iOS 设计指南

### 资源
- [Swift 文档](https://docs.swift.org/swift-book/)
- [Apple 开发者文档](https://developer.apple.com/documentation/)
- [SwiftUI 教程](https://developer.apple.com/tutorials/swiftui)
- [iOS 人机界面指南](https://developer.apple.com/design/human-interface-guidelines/)

---

*本指南为从 Kotlin 迁移到 Swift 提供了基础。请记住，两种语言都在不断发展，因此请始终参考最新文档以获取最新信息。*
