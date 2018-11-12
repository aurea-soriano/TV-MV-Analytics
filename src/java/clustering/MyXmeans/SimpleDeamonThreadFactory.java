/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package clustering.MyXmeans;



import java.util.concurrent.ThreadFactory;

/**
 * Make worker threads as daemon thread. When the main thread exits, the worker
 * threads will exit too. Otherwise, the program will hang when the main
 * thread finishes.
 *
 * @author Haifeng Li
 */
class SimpleDeamonThreadFactory implements ThreadFactory {
  public Thread newThread(Runnable r) {
    Thread t = new Thread(r);
    t.setDaemon(true);
    return t;
  }
}