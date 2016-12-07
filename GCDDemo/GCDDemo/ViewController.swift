//
//  ViewController.swift
//  GCDDemo
//
//  Created by 婉卿容若 on 2016/12/6.
//  Copyright © 2016年 婉卿容若. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // 学习地址:http://swift.gg/2016/11/30/grand-central-dispatch/
    
    @IBOutlet weak var imageView: UIImageView!
    
    var inactiveQueue: DispatchQueue!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        // syncSample()
        //asyncSample()
        //queueWithQosSyncSample()
        //queueWithQosAsyncSample()
        
        
        // conQueueSyncSample()
        // conQueueAsyncSample()
        // conQueueWithQosSyncSample()
        // conQueueWithQosAsyncSample()
        
        noAutoAction()
        if let queue = inactiveQueue {
            queue.activate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

//MARK: - 串行队列  serial
extension ViewController{
    
    // 串行同步
    func syncSample(){
        let queue = DispatchQueue(label: "com.zhengwenxiang")
        
        queue.sync {
            
            for i in 0..<10{
                print("👍 ", i)
            }
            
            print("current thread is \(Thread.current)")
        }
        
        queue.sync {
            
            for i in 20..<30{
                print("🌹 ", i)
            }
            
            print("current thread02 is \(Thread.current)")
        }
        
        for i in 100..<110{
            print("🌶 ", i)
        }
        
        print("Main thread is \(Thread.current)")
    }
    
    // 串行异步
    func asyncSample(){
        let queue = DispatchQueue(label: "com.zhengwenxiang")
        
        queue.async {
            
            for i in 0..<10{
                print("👍 ", i)
            }
            
            print("current thread is \(Thread.current)")
        }
        
        queue.async {
            
            for i in 20..<30{
                print("🌹 ", i)
            }
            
            print("current thread02 is \(Thread.current)")
        }
        
        for i in 100..<110{
            print("🌶 ", i)
        }
        print("Main thread is \(Thread.current)")
    }
    
    
    //用于指定任务重要程度以及优先级的信息，在 GCD 中被称为 Quality of Service（QoS）
    //如果没有指定 QoS，则队列会使用默认优先级进行初始化
    /* 优先级从上到下一次递减 -- priority
     userInteractive
     userInitiated
     default
     utility
     background
     unspecified
     */
    
    // 串行 + 优先级 + 同步
    func queueWithQosSyncSample(){
        let queue01 = DispatchQueue(label: "com.zhengwenxiang", qos: DispatchQoS.userInitiated)
        //  let queue01 = DispatchQueue(label: "com.zhengwenxiang", qos: DispatchQoS.background)
        // let queue02 = DispatchQueue(label: "com.zhengwenxiang02", qos: DispatchQoS.userInitiated)
        let queue02 = DispatchQueue(label: "com.zhengwenxiang02", qos: DispatchQoS.utility)
        
        queue01.sync {
            for i in 0..<10{
                print("👍 ", i)
            }
            
            print("current thread00 is \(Thread.current)")
        }
        
        queue01.sync {
            for i in 100..<110{
                print("👎 ", i)
            }
            
            print("current thread02 is \(Thread.current)")
        }
        
        
        queue02.sync {
            
            for i in 200..<210{
                print("🌶 ", i)
            }
            
            print("current thread20 is \(Thread.current)")
        }
        queue02.sync {
            
            for i in 300..<310{
                print("🐔 ", i)
            }
            
            print("current thread21 is \(Thread.current)")
        }
        
        for i in 1000..<1010 {
            print("🐷 ", i)
        }
        
        print("Main thread is \(Thread.current)")
        
    }
    
    
    // 串行 + 优先级 + 异步
    func queueWithQosAsyncSample(){
        let queue01 = DispatchQueue(label: "com.zhengwenxiang", qos: DispatchQoS.userInitiated)
        //  let queue01 = DispatchQueue(label: "com.zhengwenxiang", qos: DispatchQoS.background)
        // let queue02 = DispatchQueue(label: "com.zhengwenxiang02", qos: DispatchQoS.userInitiated)
        let queue02 = DispatchQueue(label: "com.zhengwenxiang02", qos: DispatchQoS.utility)
        
        queue01.async {
            for i in 0..<10{
                print("👍 ", i)
            }
            
            print("current thread00 is \(Thread.current)")
        }
        
        queue01.async {
            for i in 100..<110{
                print("👎 ", i)
            }
            
            print("current thread02 is \(Thread.current)")
        }
        
        
        queue02.async {
            
            for i in 200..<210{
                print("🌶 ", i)
            }
            
            print("current thread20 is \(Thread.current)")
        }
        queue02.async {
            
            for i in 300..<310{
                print("🐔 ", i)
            }
            
            print("current thread21 is \(Thread.current)")
        }
        
        for i in 1000..<1010 {
            print("🐷 ", i)
        }
        
        print("Main thread is \(Thread.current)")
        
    }
    
}

//MARK: - 并行队列 concurrent
extension ViewController{
    
    // 并行同步
    func conQueueSyncSample(){
        /*
         这个 attributes 参数也可以接受另一个名为 initiallyInactive 的值。如果使用这个值，任务不会被自动执行，而是需要开发者手动去触发。
         */
        let anotherQueue = DispatchQueue(label: "com.zhengwenxiang.con", qos: .utility, attributes: .concurrent)
        
        //initiallyInactive属性的串行队列
        //  let anotherQueue = DispatchQueue(label: "com.zhengwenxiang.con", qos: .utility, attributes: .initiallyInactive)
        
        // initiallyInactive属性的并行队列
        //  let anotherQueue = DispatchQueue(label: "com.zhengwenxiang.con", qos: .utility, attributes: [.concurrent, .initiallyInactive])
        //  inactiveQueue = anotherQueue
        
        anotherQueue.sync {
            for i in 0..<10{
                print("👍 ", i)
            }
            
            print("current thread is \(Thread.current)")
        }
        
        anotherQueue.sync {
            for i in 100..<110{
                print("🌶 ", i)
            }
            
            print("current thread02 is \(Thread.current)")
        }
        
        //        anotherQueue.async {
        //            for i in 1000..<1010 {
        //                print("🎩 ", i)
        //            }
        //        }
        
        for i in 2000..<2010 {
            print("🐷 ", i)
        }
        
        print("Main thread is \(Thread.current)")
    }
    
    
    
    
    // 并行异步
    func conQueueAsyncSample(){
        //let anotherQueue = DispatchQueue(label: "com.zhengwenxiang.con", qos: .utility)
        /*
         这个 attributes 参数也可以接受另一个名为 initiallyInactive 的值。如果使用这个值，任务不会被自动执行，而是需要开发者手动去触发。
         */
        let anotherQueue = DispatchQueue(label: "com.zhengwenxiang.con", qos: .utility, attributes: .concurrent)
        
        
        anotherQueue.async {
            for i in 0..<10{
                print("👍 ", i)
            }
            
            print("current thread is \(Thread.current)")
        }
        
        anotherQueue.async {
            for i in 100..<110{
                print("🌶 ", i)
            }
            
            print("current thread02 is \(Thread.current)")
        }
        
        //        anotherQueue.async {
        //            for i in 1000..<1010 {
        //                print("🎩 ", i)
        //            }
        //        }
        
        for i in 2000..<2010 {
            print("🐷 ", i)
        }
        
        print("Main thread is \(Thread.current)")
    }
    
    // 并行 + 优先级 + 同步
    func conQueueWithQosSyncSample(){
        
        let anotherQueue = DispatchQueue(label: "com.zhengwenxiang.con", qos: .userInitiated, attributes: .concurrent)
        let anotherQueue02 = DispatchQueue(label: "com.zhengwenxiang.con02", qos: .utility, attributes: .concurrent)
        
        anotherQueue.sync {
            for i in 0..<10{
                print("👍 ", i)
            }
            
            print("current thread00 is \(Thread.current)")
        }
        
        anotherQueue.sync {
            for i in 100..<110{
                print("🌶 ", i)
            }
            
            print("current thread01 is \(Thread.current)")
        }
        
        anotherQueue02.sync {
            for i in 1000..<1010 {
                print("🎩 ", i)
            }
            
            print("current thread20 is \(Thread.current)")
        }
        
        anotherQueue02.sync {
            for i in 2000..<2010 {
                print("🐔 ", i)
            }
            
            print("current thread21 is \(Thread.current)")
        }
        
        
        for i in 3000..<3010 {
            print("🐷 ", i)
        }
        
        print("Main thread is \(Thread.current)")
    }
    
    // 并行 + 优先级 + 异步
    
    func conQueueWithQosAsyncSample(){
        
        let anotherQueue = DispatchQueue(label: "com.zhengwenxiang.con", qos: .userInitiated, attributes: .concurrent)
        let anotherQueue02 = DispatchQueue(label: "com.zhengwenxiang.con02", qos: .utility, attributes: .concurrent)
        
        anotherQueue.async {
            for i in 0..<10{
                print("👍 ", i)
            }
            
            print("current thread00 is \(Thread.current)")
        }
        
        anotherQueue.async {
            for i in 100..<110{
                print("🌶 ", i)
            }
            
            print("current thread01 is \(Thread.current)")
        }
        
        anotherQueue02.async {
            for i in 1000..<1010 {
                print("🎩 ", i)
            }
            
            print("current thread20 is \(Thread.current)")
        }
        
        anotherQueue02.async {
            for i in 2000..<2010 {
                print("🐔 ", i)
            }
            
            print("current thread21 is \(Thread.current)")
        }
        
        
        for i in 3000..<3010 {
            print("🐷 ", i)
        }
        
        print("Main thread is \(Thread.current)")
    }
    
    
}

// MARK: - 其他

extension ViewController{
    
    // 手动开启
    func noAutoAction(){
        
        /*
         这个 attributes 参数也可以接受另一个名为 initiallyInactive 的值。如果使用这个值，任务不会被自动执行，而是需要开发者手动去触发。
         */
        
        //initiallyInactive属性的串行队列
        //  let anotherQueue = DispatchQueue(label: "com.zhengwenxiang.con", qos: .utility, attributes: .initiallyInactive)
        
        // initiallyInactive属性的并行队列
        let anotherQueue = DispatchQueue(label: "com.zhengwenxiang.con", qos: .utility, attributes: [.concurrent, .initiallyInactive])
        inactiveQueue = anotherQueue
        
        anotherQueue.sync {
            for i in 0..<10{
                print("👍 ", i)
            }
            
            print("current thread is \(Thread.current)")
        }
        
        anotherQueue.sync {
            for i in 100..<110{
                print("🌶 ", i)
            }
            
            print("current thread02 is \(Thread.current)")
        }
        
        //        anotherQueue.async {
        //            for i in 1000..<1010 {
        //                print("🎩 ", i)
        //            }
        //        }
        
        for i in 2000..<2010 {
            print("🐷 ", i)
        }
        
        print("Main thread is \(Thread.current)")
        
    }
}
