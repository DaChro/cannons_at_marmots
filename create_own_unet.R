library(keras)

#load vgg16 as base
conv_base <- application_vgg16(weights = "imagenet", include_top = FALSE, input_shape = c (224,224,3))


# optionally freeze to prevent new training
freeze_weights(conv_base)


#create first part of own model only consisting of the first few layers from vgg16 + a dropout for preventing overfitting

test_model <- conv_base$layers[[7]]$output %>% layer_dropout(rate = 0.5)
conclayer1 <- conv_base$layers[[6]]$output
conclayer2 <- conv_base$layers[[3]]$output

# add the second part of 'U' for segemntation

#conv
test_model <- layer_conv_2d(test_model, dtype = "float32", filters = 256, kernel_size = 3, padding = "same", data_format = "channels_last", activation = "relu", kernel_initializer = "VarianceScaling" )

test_model <- layer_conv_2d(test_model, dtype = "float32", filters = 256, kernel_size = 3, padding = "same", data_format = "channels_last", activation = "relu", kernel_initializer = "VarianceScaling" )

#up-convolution 1
test_model <- layer_conv_2d_transpose(test_model, dtype = "float32", filters = 128, kernel_size = 2, strides = 2, padding = "same", data_format = "channels_last", activation = "linear")


# concatenation 1
test_model <- layer_concatenate(list(conclayer1, test_model))


# convolution 
test_model <- layer_conv_2d(test_model, dtype = "float32", filters = 128, kernel_size = 3, padding = "same", data_format = "channels_last", activation = "relu", kernel_initializer = "VarianceScaling" )

test_model <- layer_conv_2d(test_model, dtype = "float32", filters = 128, kernel_size = 3, padding = "same", data_format = "channels_last", activation = "relu", kernel_initializer = "VarianceScaling" )


#up-convolution 2
test_model <- layer_conv_2d_transpose(test_model, dtype = "float32", filters = 64, kernel_size = 2, strides = 2, padding = "same", data_format = "channels_last", activation = "linear")

# concatenation 2
test_model <- layer_concatenate(list(conclayer2, test_model))


#final convolution
test_model <- layer_conv_2d(test_model, dtype = "float32", filters = 64, kernel_size = 3, padding = "same", data_format = "channels_last", activation = "relu", kernel_initializer = "VarianceScaling" )

test_model <- layer_conv_2d(test_model, dtype = "float32", filters = 64, kernel_size = 3, padding = "same", data_format = "channels_last", activation = "relu", kernel_initializer = "VarianceScaling" )

#output
test_model <- layer_conv_2d(test_model, dtype = "float32", filters = 1, kernel_size = 1, padding = "valid", data_format = "channels_last", activation = "sigmoid")



#add input and create model
test_model <- keras_model(inputs = conv_base$input, outputs = test_model)
test_model




#compile
test_model %>% compile(
  loss = "binary_crossentropy",
  optimizer = optimizer_rmsprop(lr = 2e-5),
  metrics = c("accuracy")
)



######smaller version of that model with only one max pool (here I add dropout after the conv. layer in order to keep these layers trained as in vgg)####

# this time I use the first 6 layers of vgg16, I do not add own conv layers, but use layers 
# 5 and 6, and add dropout afterwards
test_model <- conv_base$layers[[6]]$output %>% layer_dropout(rate = 0.5)
conclayer <- conv_base$layers[[3]]$output


#up-convolution 
test_model <- layer_conv_2d_transpose(test_model, dtype = "float32", filters = 64, kernel_size = 2, strides = 2, padding = "same", data_format = "channels_last", activation = "linear")


# concatenation 1
test_model <- layer_concatenate(list(conclayer, test_model))


# convolution 
test_model <- layer_conv_2d(test_model, dtype = "float32", filters = 64, kernel_size = 3, padding = "same", data_format = "channels_last", activation = "relu", kernel_initializer = "VarianceScaling" )

test_model <- layer_conv_2d(test_model, dtype = "float32", filters = 64, kernel_size = 3, padding = "same", data_format = "channels_last", activation = "relu", kernel_initializer = "VarianceScaling" )

#output
test_model <- layer_conv_2d(test_model, dtype = "float32", filters = 1, kernel_size = 1, padding = "valid", data_format = "channels_last", activation = "sigmoid")


#add input and create model
test_model <- keras_model(inputs = conv_base$input, outputs = test_model)
test_model






















