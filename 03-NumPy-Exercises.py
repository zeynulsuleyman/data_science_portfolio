#!/usr/bin/env python
# coding: utf-8

# ___
# 
# <a href='http://www.pieriandata.com'><img src='../Pierian_Data_Logo.png'/></a>
# ___
# <center><em>Copyright Pierian Data</em></center>
# <center><em>For more information, visit us at <a href='http://www.pieriandata.com'>www.pieriandata.com</a></em></center>

# # NumPy Exercises
# 
# Now that we've learned about NumPy let's test your knowledge. We'll start off with a few simple tasks and then you'll be asked some more complicated questions.
# 
# <div class="alert alert-danger" style="margin: 10px"><strong>IMPORTANT NOTE!</strong> Make sure you don't run the cells directly above the example output shown, <br>otherwise you will end up writing over the example output!</div>

# #### 1. Import NumPy as np

# In[1]:


import numpy as np


# #### 2. Create an array of 10 zeros 

# In[2]:


np.zeros(10)


# In[2]:


# DON'T WRITE HERE


# #### 3. Create an array of 10 ones

# In[3]:


np.ones(10)


# In[3]:


# DON'T WRITE HERE


# #### 4. Create an array of 10 fives

# In[6]:


np.full(10, 5, dtype=float)


# In[50]:


np.ones(10) + 4


# In[51]:


np.ones(10) * 5


# In[4]:


# DON'T WRITE HERE


# #### 5. Create an array of the integers from 10 to 50

# In[8]:


np.arange(10, 51)


# In[5]:


# DON'T WRITE HERE


# #### 6. Create an array of all the even integers from 10 to 50

# In[9]:


np.arange(10, 51, 2)


# In[6]:


# DON'T WRITE HERE


# #### 7. Create a 3x3 matrix with values ranging from 0 to 8

# In[53]:


np.arange(9).reshape(3, 3)


# In[12]:


np.array([[0, 1, 2], [3, 4, 5], [6, 7, 8]])


# In[7]:


# DON'T WRITE HERE


# #### 8. Create a 3x3 identity matrix

# In[54]:


np.eye(3)


# In[13]:


np.eye(3, 3)


# In[8]:


# DON'T WRITE HERE


# #### 9. Use NumPy to generate a random number between 0 and 1<br><br>&emsp;NOTE: Your result's value should be different from the one shown below.

# In[15]:


np.random.rand(1)


# In[9]:


# DON'T WRITE HERE


# #### 10. Use NumPy to generate an array of 25 random numbers sampled from a standard normal distribution<br><br>&emsp;&ensp;NOTE: Your result's values should be different from the ones shown below.

# In[17]:


np.random.randn(25)


# In[10]:


# DON'T WRITE HERE


# #### 11. Create the following matrix:

# In[63]:


(np.arange(1, 101) / 100).reshape(10, 10)


# In[11]:


# DON'T WRITE HERE


# #### 12. Create an array of 20 linearly spaced points between 0 and 1:

# In[31]:


np.linspace(0, 1, 20)


# In[12]:


# DON'T WRITE HERE


# ## Numpy Indexing and Selection
# 
# Now you will be given a starting matrix (be sure to run the cell below!), and be asked to replicate the resulting matrix outputs:

# In[32]:


# RUN THIS CELL - THIS IS OUR STARTING MATRIX
mat = np.arange(1,26).reshape(5,5)
mat


# #### 13. Write code that reproduces the output shown below.<br><br>&emsp;&ensp;Be careful not to run the cell immediately above the output, otherwise you won't be able to see the output any more.

# In[33]:


mat[2:, 1:]


# In[14]:


# DON'T WRITE HERE


# #### 14. Write code that reproduces the output shown below.

# In[34]:


mat[3, 4]


# In[15]:


# DON'T WRITE HERE


# #### 15. Write code that reproduces the output shown below.

# In[64]:


mat[:3, 1:2]


# In[36]:


mat[:3, 1].reshape(3, 1)


# In[16]:


# DON'T WRITE HERE


# #### 16. Write code that reproduces the output shown below.

# In[67]:


mat[4]


# In[65]:


mat[4, :]


# In[37]:


mat[4, ::]


# In[17]:


# DON'T WRITE HERE


# #### 17. Write code that reproduces the output shown below.

# In[66]:


mat[3:, :]


# In[68]:


mat[3:5]


# In[38]:


mat[3:, ::]


# In[18]:


# DON'T WRITE HERE


# ## NumPy Operations

# #### 18. Get the sum of all the values in mat

# In[47]:


mat.sum()


# In[40]:


np.sum(mat)


# In[19]:


# DON'T WRITE HERE


# #### 19. Get the standard deviation of the values in mat

# In[46]:


mat.std()


# In[41]:


np.std(mat)


# In[20]:


# DON'T WRITE HERE


# #### 20. Get the sum of all the columns in mat

# In[45]:


mat.sum(axis=0)


# In[44]:


np.sum(mat, axis=0)


# In[21]:


# DON'T WRITE HERE


# ## Bonus Question
# 
# We worked a lot with random data with numpy, but is there a way we can insure that we always get the same random numbers? [Click Here for a Hint](https://www.google.com/search?q=numpy+random+seed&rlz=1C1CHBF_enUS747US747&oq=numpy+random+seed&aqs=chrome..69i57j69i60j0l4.2087j0j7&sourceid=chrome&ie=UTF-8)

# In[72]:


np.random.seed(101)
np.random.rand(1)


# # Great Job!
