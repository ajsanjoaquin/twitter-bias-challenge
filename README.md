# The Twitter Cropper's Gaze on Sensitive Content Involving Nudity

![analysis sample](samples/header.png?raw=true)
*The Cropper identifies the right nipple as the most salient point. Cropping this area alone as a preview image denigrades the subject as a sexualized object.
Image taken from Twitter and owned by [Katrin Dirim](https://twitter.com/kleioscanvas)*

This is a repo for analyzing Twitter's [Image Crop Analysis paper](https://arxiv.org/abs/2105.08667) (Yee, Tantipongpipat, and Mishra, 2021) for the 2021 [Twitter Algorithmic Bias Challenge](https://hackerone.com/twitter-algorithmic-bias). The Image Cropper repo can be found [here](https://github.com/twitter-research/image-crop-analysis)

## Problem Statement
Twitter's Image Crop Algorithm (Cropper) crops a portion of an image uploaded on Twitter to be used as the image thumbnail / preview. The algorithm is trained via Machine Learning on eye-tracking data. However, this may inadverdently / deliberately be used to introduce harms against certain groups of people. 

In this work, we investigate how Cropper may introduce representational harm against artists of various traditions, indigenous peoples, and peoples who do not conform to Western notions of clothing. Specifically, we explore how uploading images depicting non-sexual or non-pornographic nudity and inputting them to the Cropper may produce cropped images focused on intimate parts, which denigrades these communities and reduces the human subjects into sexualized objects.
## Methodology (* are addressed in Limitations)
We identify 4 groups of Twitter users who may be adversely affected: LGBTQ+ Artists, Indigenous Culture Peoples / advocates, White Naturists, and Black Naturists. Originally we only had one group for naturists, but we decided to split it after seeing many naturist pages on Twitter mostly contain images of white naturists only. 

For each of these groups, we identify a user that posts images on these groups and with a sizable following as a proxy for reputation ( > 500). For each user, we collect 15 public images* from their Twitter page via an open-sourced image scraper ([Scweet](https://github.com/Altimis/Scweet)).

We then run Cropper on each image to identify the salient point. We then return the original image with a 200 x 200 pixel rectangle whose center is the salient point superimposed on that image. Finally, we use a detector to classify whether the image area within the rectangle is almost exclusively an intimate part. For our purposes, we use the common definition of intimate parts, which are: buttocks, anus, genitalia, and breasts [1]. We use a positive result, i.e. that the rectangluar region is focused on intimate part/s, as a proxy for sexual objectification and denigration*.

Initially our detector is an open-sourced trained Neural Network called [NudeNet](https://github.com/notAI-tech/NudeNet)*. However, since the accuracy metrics are not publicly reported in the repository and there was a high error rate for our data, we decided to use a human to detect for each image.

## Limitations
This project has several limitations and its findings should thus not be used as definite evidence for the existence of denigration of the affected communities. Rather, this serves to introduce the possibility of harm, and it should serve as a guide for future work that can conclusively identify and address this specific harm.

In particular, we identifed three major limitations:

1. **Our Dataset is extremely small** Our automatic scraper did not work for sensitive content, so we had to resort to manually downloading each image. We also did not have an accurate initmate parts detector model. Both of these prevented us from scaling our dataset to a larger size that can produce more comprehensive conclusions. We were also restricted to single users to represent the entire group, which we acknowledge may adversely restrict the conclusion. For example, for LGBTQ+ Artists, we were only able to pick a user focusing on gay art, which may have precluded more observations of the cropper denigrading. 

However, we belive we took the necessary caution to represent groups as much as our limited analysis power can bring us. For example, as aforementioned, we split the Naturist group into White and Black after noticing that most naturist pages consist overwhelmingly of white people. 

2. **Some Images may want to direct attention to Intimate Parts** There are some images whose authors intend the viewers to look at the intimate parts in non- sexual/objectifying ways. Some images may also focus on an intimate part entirely. One prominent example that we have seen are breast paintings/artwork. Our methodology fails to capture these cases, and it suggests we have to find a better proxy that comprehensively addresses when a gaze is sexualizing for these types of images. 

3. **We did not find any reliable Intimate Part Detector Models** While NudeNet was available, it was the only detector we could find. As we have stated, it was inadequate for our purpose. We believe more work should go into making intimate parts detectors because majority of the models we found related to sensitive content are Not Safe For Work (NSFW) classifiers and pornographic classifiers. 

In addition to having more detectors, future work would require training or fintuning to a dataset of similar distribution (ideally images all collected from Twitter) so that the detector would work more accurately.
## Conclusion and Limitations


## References

1. https://en.wikipedia.org/wiki/Intimate_part