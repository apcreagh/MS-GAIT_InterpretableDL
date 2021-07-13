# Interpretable Deep Learning for the Remote Characterisation of Ambulation in Multiple Sclerosis using Smartphones
Software detaling an interpretable deep learning framework applied to smartphone-based inertial sensor data for remote patient monitoring (RPM) of people with multiple sclerosis (PwMS) and healthy controls (HC). <br />

Layer-wise Relevance Propagation (LRP) can then be used to visualise DCNN decision by attributing relevance to the individual input data. Relevance scores can be projected by LRP directly back onto the raw time-series input, enabling the contribution of relevant and contradictory sensor patterns reflective of those who are healthy versus PwMS. LRP was implemeted using the iNNvestigate toolbox. iNNvestigate can be installed with the following commands: 
```bash
pip install innvestigate
```
For more information we direct the reader to: https://github.com/albermax/innvestigate 

If using this code, please cite: <br />
Creagh, A.P., Lipsmeier, F., Lindemann, M., and De Vos, M. Interpretable deep learning for the remote characterisation of ambulation in multiple sclerosis using smartphones. Sci Rep 11, 14301 (2021). https://doi.org/10.1038/s41598-021-92776-x
 
Deep networks were built using Python v3.7.4. through a Keras framework v2.2.4 with a Tensorflow v1.14 back-end. The iNNvestigate library is based on Keras and  requires a supported Keras-backend a Tensorflow backend (tested with Python v3.6, Tensorflow v1.12):

## Acknowledgment 
This author is affiliated with the Institute of Biomedical Engineering, Department of Engineering Science, University of Oxford. Contact: andrew.creagh@eng.ox.ac.uk 

## License 
Released under the GNU General Public License v3
This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. <br />
You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
