# Machine vision based similarity modeling of rock fractures in tunnel face
## Graduate Thesis
1. Proposed a visualization method of discrete fracture network with randomly generated fracture trace maps based on machine vision methods and statistical principles using Python language, and thus established a complete discrete fracture network similarity evaluation system.
2. Proposed a pointing plus gridding algorithm to accurately calculate the position and density similarity of trace maps, innovatively took spacing similarity index into the calculation of comprehensive similarity
3. Applied the established system to the actual project to test its reliability and applicability

## 1.Background
Similarity evaluation of rock tunnel workface fractures is an important topic of profound concern for engineers and researchers in fractured rock modeling work. At present, the widely used method to measure and analyze the fissures of rock is still based on the professionals carrying geological compasses, rulers, measuring lines, and other tools to survey and draw the fissures of rocks on site, and then collate the obtained data and draw them on the drawings. This kind of method has the advantages of simple and direct operation, but 1. high labor cost,2. low efficiency of detection, 3.manual operation, and other disadvantages are inevitable. With the continuous development of computer technology, non-contact measurement led by machine vision gradually began to be widely used in practical engineering. Therefore, the non-contact data acquisition method is gradually used as the data source for rock joint fracture model establishment. On the other hand, the fracture network established by contact measurement data cannot meet the development of the growing visual information technology in terms of accuracy and efficiency due to the disadvantages of statistical localization and subjectivity, so there is an urgent need to explore a simpler and more efficient method to analyze the similarity of fracture modeling in rock tunnel working face and ensure the reliability of the fracture model established by combining machine vision extraction.

## 2.Method
### A visualization method of discrete fracture network with randomly generated nodal fracture trace maps
Here is the general flowchart:
![image](https://user-images.githubusercontent.com/39005000/197426629-689b432f-7281-4d0a-83f2-0019573ca871.png)

1. Calculate the projection distance
![image](https://user-images.githubusercontent.com/39005000/197426878-47033747-eae6-438a-b2ab-ba38d5197816.png)
2. Generate the projection points
3. 
![image](https://user-images.githubusercontent.com/39005000/197426920-87a53430-5270-4248-8574-4c44127db813.png)
4. Downsampling
![image](https://user-images.githubusercontent.com/39005000/197427033-0e164637-bd4a-47be-8134-ca438c48866b.png)
5. After repeat the above steps for specific times, the final map can be generated.
![image](https://user-images.githubusercontent.com/39005000/197427037-7462d9af-ea8f-4c51-bd03-f7859ace9b81.png)


### 



## 3.Experiment

### 3.3 Sensitivity Analysis
![image](https://user-images.githubusercontent.com/39005000/198191135-34430ed5-3225-4d5b-bcc4-eac167fe3b78.png)
|   | Angle|Length| Distance|
|---|---|---|---|
|scope| -1.205|-0.878|-0.697|
|intercept| 81.344|81.853|82.343|
## 4.Conclusion
