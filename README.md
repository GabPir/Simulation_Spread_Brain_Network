# Simulating the Spread of Hyperphosphorylated Tau Proteins in a Human Brain Network
## Project for "Modelli matematici per la Biomedicina" (Course 2023/2024)

Alzheimer's disease is characterized by the propagation of beta-amyloid and tau proteins, which form plaques and neurofibrillary tangles. It is possible to simulated the diffusion of tau protein in the brain and its elimination. As simulating in a continuous space resembling the brain incurs high computational costs, the continuous models and their governing equations can be discretized using a human brain network model. 
<br>
The proposed mathematical models are:  
(1) Fisher–Kolmogorov model  
(2) Population model with structure (age)  
<br>
Data source: https://pitgroup.org/connectome/
<br><br>
### Discretization on a graph 
Nodes are associated with an area in the brain, and edges represent empirical measurements (e.g., average number of fibers). It has been observed that hyperphosphorylated tau proteins spread from
a small infected region along axonal fiber tracts throughout the entire brain. It is possible to model this spreading as diffusion across the brain’s connectome, represented as a weighted undirected graph G with N nodes and E edges. In order to properly define the diffusion term, the Discrete Laplacian operator is considered.
<br>
![immagine](https://github.com/user-attachments/assets/f518a1bf-187d-4510-896e-642074b4422e)
<br><br>

### Fisher-Kolmogorov Model (discrete)
Through discretization of the brain space into a network of nodes, the Fisher-Kolmogorov model can be rewritten as a system of ODEs:
<br>

![immagine](https://github.com/user-attachments/assets/258aeecd-9e92-4ae7-ab17-00d8c159aaee)
<br>

![immagine](https://github.com/user-attachments/assets/d18d88db-08a6-4a6b-a2ec-17e21d4b229b)
<br><br>

### Age-Structured Model 
The proposed population model with age structure assumes that proteins become increasingly less eliminable with age, aggregating and forming protein tangles. Everything can be represented by a transport equation by making assumptions about the growth rate and variation in the clearance rate of the population:
<br> 

![immagine](https://github.com/user-attachments/assets/5f655be4-8f1e-41d0-ba1a-8e9a9437ccff)
<br>
![immagine](https://github.com/user-attachments/assets/21a0c603-7395-4e8b-b25f-740f549bfd92)


<br>

### Final Results
What has been achieved with the proposed Age-Structured model is a better representation of the disease's evolution, avoiding the exponential growth observed in almost all nodes in the FK model, which poorly represents the disease's stages of development. Additionally, it accounts for the age and decreasing clearance of aggregated proteins.
<br> 

![immagine](https://github.com/user-attachments/assets/303ef480-3d5c-4706-b368-8764ab3c178d)
<br> 
![immagine](https://github.com/user-attachments/assets/8337f9b4-7c71-4ad3-8d79-285ebb3e7d28)
<br>
 Brain visualization tool:
 Mingrui, et al. “BrainNet Viewer: A Network Visualization Tool for Human Brain Connectomics.” PLoS ONE, edited by Peter Csermely, vol. 8, no. 7, Public Library of Science (PLoS), July 2013, p. e68910, doi:10.1371/journal.pone.0068910. 
 <br>
