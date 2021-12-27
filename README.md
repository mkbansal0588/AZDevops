# Azure DevOps Workshop

## What is DevOps?

Before we dived into world of Azure DevOps let's understand what is DevOps? DevOps is composed of two words. Dev for development and Ops for operations. In a nutshell, DevOps is about the cooperation between software development and production management – between the developers and the operational teams. 

DevOps is based on the basic principles of Agile: the focus on individuals, interactions, and cooperation. The most significant difference is that DevOps continues this direction through the whole organization instead of only within the development process. DevOps can therefore be most accurately described as a culture within an organization that rests upon three pillars, namely tools, processes, and people.

To apply the definition to practice, let's understand the various phases of software development lifecycle. The lifecycle comprises eight phases: plan, code, build, test, release, deploy, operate, and monitor. The phases are cycled through continuously by interdisciplinary teams in order to be able to deliver new software quickly. 

![image](https://user-images.githubusercontent.com/19226157/147508712-04333452-22b0-4e99-9783-220b533761fc.png)

These eight phases can be subdivided into a number of important and undoubtedly familiar development steps. 

### 1. Continuous Development (Plan and Code)
In this phase, activities are continuously identified and monitored visually (e.g., with Kanban and Agile). Consequently, all stakeholders have a clear picture of the team’s capacities and tasks can be easily distributed and prioritized. The software for delivery is split into multiple sprints or short development cycles. Code is shared with the aid of a version control system such as Git. 
 

### 2. Continuous Integration (Build and Test)
In this phase, new code is tested for bugs. The quality assurance (QA) team safeguards the quality of the software and tests its capability of satisfying the requirements in different test environments. The validated code can then be safely and continuously integrated with the master branch. Testing for bugs early on allows them to be rectified quickly and easily. 


### 3. Continuous Deployment (Release and Deploy)
Once the new version of the software has been tested and validated, it can be transferred to the production environment. This begins with implementation of the new code on the servers and results in the ultimate production or deployment. This way, end users have direct access to new functions.

 

### 4. Continuous Monitoring (Operate and Monitor)
Once the new software goes live, the operations team can use monitoring to obtain information about the performance and usage patterns of the app. The operations team monitors the occurrence of bugs and other problems during usage of the software. Data are collected with an eye to future developments, which can in turn be picked up by the development team. 

## What is Azure DevOps?

As you know, Azure is Microsoft’s cloud computing platform – a collection of services offered by Microsoft from its data centers. One of those services is Azure DevOps (previously VSTS), an environment that incorporates a range of services designed to ensure easy integration of DevOps within your organization. 


You can add to the Azure DevOps services with the tools of your choice. So, whether you’re a Java, Node, or .Net developer or work in Jenkins, Ansible, or Puppet, Azure DevOps allows you to set up your end-to-end DevOps chain yourself. 


Azure DevOps Services
The following is a brief outline of the Azure DevOps services. You can opt to use them all or choose only the services that you need to complement your existing operational processes.


![image](https://user-images.githubusercontent.com/19226157/147509765-d989dde6-d46e-4f29-b814-37c5e3ef2127.png)

### Azure Boards
Allows you to plan, monitor, and discuss your teams’ activities.


![image](https://user-images.githubusercontent.com/19226157/147509843-b4b82181-59e9-4d9a-80d6-d1977e7d2bee.png)

### Azure Pipelines
Azure Pipelines comprises a CI/CD pipeline that works for virtually any activity, platform, and cloud. With the aid of a Git provider, you can carry out continuous development, testing, and implementation. 


![image](https://user-images.githubusercontent.com/19226157/147509872-c41de9c9-d773-45fc-928a-5876faf56e8b.png)

### Azure Repos
Azure Repos gives you an unlimited number of Git repositories in the cloud. Pull requests and advanced file management allow people and teams to work efficiently.


![image](https://user-images.githubusercontent.com/19226157/147509886-8958cfbc-ac76-4041-83fd-98c204427304.png)

### Azure Test Plans
Manual and exploratory test programs allow software to be both tested and released quickly and thoroughly.


![image](https://user-images.githubusercontent.com/19226157/147509897-21a4f4b2-c680-4fc1-8df1-baf3ff345afc.png)

### Azure Artifacts
Azure Artifacts allows you to share code easily with different teams and organizations. You can share packages and add them to your pipelines.

 
### Extensions Marketplace
Lastly, Azure DevOps also offers an Extensions Marketplace, which contains more than one thousand extensions that you can add to your Azure DevOps environment, such as Slack, Jenkins, Docker, and Kubernetes.




