#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/sched.h>
#include <linux/sched/signal.h>
#include <linux/mm.h>
#include <linux/version.h>

#define PROC_NAME "sysmon"

static struct proc_dir_entry *proc_entry;

static void show_process_info(struct seq_file *m, struct task_struct *task)
{
    char comm[TASK_COMM_LEN];
    get_task_comm(comm, task);
    
    seq_printf(m, "PID: %d\tName: %s\tState: %c\tCPU: %d\tMemory: %lu KB\n",
               task->pid,
               comm,
               task_state_to_char(task),
               task_cpu(task),
               get_mm_rss(task->mm) << (PAGE_SHIFT - 10));
}

static int proc_show(struct seq_file *m, void *v)
{
    struct task_struct *task;
    
    seq_printf(m, "Process Monitor - Real-time Process Information\n");
    seq_printf(m, "=============================================\n");
    
    for_each_process(task) {
        if (task->mm) {  // Only show processes with memory context
            show_process_info(m, task);
        }
    }
    
    return 0;
}

static int proc_open(struct inode *inode, struct file *file)
{
    return single_open(file, proc_show, NULL);
}

static const struct proc_ops proc_fops = {
    .proc_open = proc_open,
    .proc_read = seq_read,
    .proc_lseek = seq_lseek,
    .proc_release = single_release,
};

static int __init sysmon_init(void)
{
    proc_entry = proc_create(PROC_NAME, 0, NULL, &proc_fops);
    if (proc_entry == NULL) {
        printk(KERN_ERR "SysMon: Error creating proc entry\n");
        return -ENOMEM;
    }
    
    printk(KERN_INFO "SysMon: Module loaded\n");
    return 0;
}

static void __exit sysmon_exit(void)
{
    remove_proc_entry(PROC_NAME, NULL);
    printk(KERN_INFO "SysMon: Module unloaded\n");
}

module_init(sysmon_init);
module_exit(sysmon_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Anant Narayan");
MODULE_DESCRIPTION("A real-time process monitoring kernel module");
MODULE_VERSION("0.1");
