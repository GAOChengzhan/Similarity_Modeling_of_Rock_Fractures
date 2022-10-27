# Machine vision based similarity modeling of rock fractures in tunnel face
## Graduate Thesis
1. Proposed a visualization method of discrete fracture network with randomly generated fracture trace maps based on machine vision methods and statistical principles using Python language, and thus established a complete discrete fracture network similarity evaluation system.
2. Proposed a pointing plus gridding algorithm to accurately calculate the position and density similarity of trace maps, innovatively took spacing similarity index into the calculation of comprehensive similarity
3. Applied the established system to the actual project to test its reliability and applicability

## 1.Background
There are basically TWO WAYS to get the trace maps of a certain tunnel face:

<img src="https://user-images.githubusercontent.com/39005000/198196699-92ae95e2-5448-4d3e-80ed-b9f38a63d084.png" alt="drawing" width="700"/>

<img src="https://user-images.githubusercontent.com/39005000/198196823-19f11606-f703-4c93-ae72-1746a4c5a4fb.png" alt="drawing" width="350"/><img src="https://user-images.githubusercontent.com/39005000/198196714-a04c4ce2-0d38-462d-ac88-7de4e1e33e67.png" alt="drawing" width="350"/>


How to compare two trace maps

<img src="https://user-images.githubusercontent.com/39005000/198196652-e532da23-2f7e-4354-9964-02c28b60e27b.png" alt="drawing" width="800"/>

Similarity evaluation of rock tunnel workface fractures is an important topic of profound concern for engineers and researchers in fractured rock modeling work. At present, the widely used method to measure and analyze the fissures of rock is still based on the professionals carrying geological compasses, rulers, measuring lines, and other tools to survey and draw the fissures of rocks on site, and then collate the obtained data and draw them on the drawings. This kind of method has the advantages of simple and direct operation, but 1. high labor cost,2. low efficiency of detection, 3.manual operation, and other disadvantages are inevitable. With the continuous development of computer technology, non-contact measurement led by machine vision gradually began to be widely used in practical engineering. Therefore, the non-contact data acquisition method is gradually used as the data source for rock joint fracture model establishment. On the other hand, the fracture network established by contact measurement data cannot meet the development of the growing visual information technology in terms of accuracy and efficiency due to the disadvantages of statistical localization and subjectivity, so there is an urgent need to explore a simpler and more efficient method to analyze the similarity of fracture modeling in rock tunnel working face and ensure the reliability of the fracture model established by combining machine vision extraction.


## 2.Method
### Visualization method of discrete fracture network 
Proposed a visualization method of discrete fracture network with randomly generated nodal fracture trace maps based on machine vision methods and statistical principles using Python language
Here is the general flowchart:

<img src="https://user-images.githubusercontent.com/39005000/197426629-689b432f-7281-4d0a-83f2-0019573ca871.png" alt="drawing" width="600"/>

1. Calculate the projection distance

<img src="https://user-images.githubusercontent.com/39005000/197426878-47033747-eae6-438a-b2ab-ba38d5197816.png" alt="drawing" width="350"/>

<img src="https://user-images.githubusercontent.com/39005000/198197106-585ee920-cda6-4466-9e8b-28d88b0efdbf.png" alt="drawing" width="250"/>

2. Generate the projection points

<img src="https://user-images.githubusercontent.com/39005000/198197123-cf44f97b-6a36-43ee-9e49-653db987f010.png" alt="drawing" width="400"/>

3. Generate the guidelines of center points


<img src="https://user-images.githubusercontent.com/39005000/197426920-87a53430-5270-4248-8574-4c44127db813.png" alt="drawing" width="350"/>

4. Get the direction and length sequences and generate the centre points

Two Sequences

<img src="https://user-images.githubusercontent.com/39005000/198197355-0fc5c81c-2753-4acc-abdc-0d03ad20d950.png" alt="drawing" width="250"/>

<img src="https://user-images.githubusercontent.com/39005000/198197248-0d8f5838-5768-436b-9bc0-0e455a54cab0.png" alt="drawing" width="350"/>

5. Downsampling

![image](https://user-images.githubusercontent.com/39005000/197427033-0e164637-bd4a-47be-8134-ca438c48866b.png)

6. After repeat the above steps for specific times, the final map can be generated.

![image](https://user-images.githubusercontent.com/39005000/197427037-7462d9af-ea8f-4c51-bd03-f7859ace9b81.png)


### 2.2 Similarity Evaluation System
Established a complete discrete fracture network similarity evaluation system

Here is the general flowchart:
![image](https://user-images.githubusercontent.com/39005000/198194191-79234f4b-929f-47a0-a7dd-2a4287350dd0.png)

#### 2.2.1 Direction Similarity
<img src="https://user-images.githubusercontent.com/39005000/198194766-5b34f02b-669b-410a-845e-320927235746.png" alt="drawing" width="350"/><img src="https://user-images.githubusercontent.com/39005000/198194773-e67df835-ae10-4375-a44f-fc0915e2df94.png" alt="drawing" width="350"/>

<img src="https://user-images.githubusercontent.com/39005000/198194780-84165c57-1112-4d7b-87eb-bb97576b048f.png" alt="drawing" width="700"/>

- Step1: get the distribution of two direction sets
- Step2: use Wasserstein Algorithm to calculate the dissimilarity
- Step3: get the similarity index


<img src="https://user-images.githubusercontent.com/39005000/198195004-5a37ca45-c5d3-4ea1-8b53-61192632e861.png" alt="drawing" width="450"/>

#### 2.2.2 Length Similarity

##### Overall Length Similarity

<img src="https://user-images.githubusercontent.com/39005000/198195340-11231b50-0b68-477d-984f-b1e19e086ea5.png" alt="drawing" width="700"/>

##### Length Similarity by Group

<img src="https://user-images.githubusercontent.com/39005000/198195334-0d3e0ec1-2a5b-4814-b4ce-1dd87b5aa01b.png" alt="drawing" width="700"/>


#### 2.2.3 Spacing Similarity
![image](https://user-images.githubusercontent.com/39005000/198195409-4cdd940a-93c8-48d2-96c7-18c3760b66e8.png)
![image](https://user-images.githubusercontent.com/39005000/198195419-5a4c539a-ddd5-4aed-9136-13ebda0eb913.png)

<img src="https://user-images.githubusercontent.com/39005000/198195427-ec020bb7-7b72-42a2-ba19-04f839dc4f87.png" alt="drawing" width="700"/>

- Step1: determine a certain group in map1 is to be compared with which group in map2
- Step2: compare the spacing respectively
- Step3: get the spacing index

<img src="https://user-images.githubusercontent.com/39005000/198195557-15c18588-d0e0-4485-8726-b562d593af3b.png" alt="drawing" width="400"/>

#### 2.2.4 Location Similarity
<img src="https://user-images.githubusercontent.com/39005000/198195990-08316d6a-5a93-48da-a2b7-f4203f227414.png" alt="drawing" width="700"/>

- Step1 Original Map
- Step2 Line to Point
- Step3 Grid
- Step4 Calculate Gravity Points
##### Overall Location Similarity
![image](https://user-images.githubusercontent.com/39005000/198195928-a7ce5762-3dfb-4f82-851d-ffc6cab43d03.png)
##### Location Similarity by Group
![image](https://user-images.githubusercontent.com/39005000/198195921-0708620d-2ada-4619-98c4-62cc1422e5d4.png)

#### 2.2.4 Density Similarity

<img src="https://user-images.githubusercontent.com/39005000/198196109-3eb90204-649c-4c70-a968-bde67d753045.png" alt="drawing" width="700"/>
- Step1 Original Map
- Step2 Line to Point
- Step3 Grid
- Step4 Count Points

##### Overall Density Similarity
![image](https://user-images.githubusercontent.com/39005000/198196143-27ed1fa8-bc55-4444-94d7-86c0bc039cec.png)

##### Density Similarity by Group
![image](https://user-images.githubusercontent.com/39005000/198196150-55e51fc7-80b7-492e-9cda-d01262c96c3b.png)
![image](https://user-images.githubusercontent.com/39005000/198196157-4c79b468-808f-4edc-a7b5-4986a5801854.png)

## 3.Experiment
### 3.1 Case 1
![image](https://user-images.githubusercontent.com/39005000/198191638-f39ffd42-e48a-4f9d-96e8-26c739f237e2.png)
### 3.2 Case 2
![image](https://user-images.githubusercontent.com/39005000/198191682-09bf75c1-4e14-4351-9ded-922d7fd329a9.png)
Sample Window
![image](https://user-images.githubusercontent.com/39005000/198191689-2406adb7-0541-4df3-9df5-c6015910be1f.png)
Simulated Trace Maps
![image](https://user-images.githubusercontent.com/39005000/198191724-e912f36c-9d1e-4247-8c5c-ae7495ee60e9.png)
Results:
|   |   |   |   |   |   |
|---|---|---|---|---|---|
|   |   |   |   |   |   |
|   |   |   |   |   |   |
|   |   |   |   |   |   |
|   |   |   |   |   |   |
### 3.3 Sensitivity Analysis
![image](https://user-images.githubusercontent.com/39005000/198191135-34430ed5-3225-4d5b-bcc4-eac167fe3b78.png)
|   | Angle|Length| Distance|
|---|---|---|---|
|slope| -1.205|-0.878|-0.697|
|intercept| 81.344|81.853|82.343|
## 4.Conclusion
