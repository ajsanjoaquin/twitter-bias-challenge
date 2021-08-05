# The Twitter Cropper's Gaze on Sensitive Content Involving Nudity

![analysis sample](img_md/header.png?raw=true)
*The Cropper identifies the right nipple as the most salient point. Cropping this area alone as a preview image denigrades the subject as a sexualized object.
Image taken from Twitter and owned by [Katrin Dirim](https://twitter.com/kleioscanvas)*

This is a repo for analyzing Twitter's [Image Crop Analysis paper](https://arxiv.org/abs/2105.08667) (Yee, Tantipongpipat, and Mishra, 2021) for the 2021 [Twitter Algorithmic Bias Challenge](https://hackerone.com/twitter-algorithmic-bias). The Image Cropper repo can be found [here](https://github.com/twitter-research/image-crop-analysis)

## Problem Statement
Twitter's Image Crop Algorithm (Cropper) crops a portion of an image uploaded on Twitter to be used as the image thumbnail / preview. The algorithm is trained via Machine Learning on eye-tracking data. However, this may inadverdently / deliberately be used to introduce harms against certain groups of people. 

In this work, we investigate how Cropper may introduce representational harm against artists of various traditions, indigenous peoples, and communities who do not conform to Western notions of clothing. Specifically, we explore how uploading images depicting non-sexual or non-pornographic nudity and inputting them to the Cropper may produce cropped images focused on intimate parts, which denigrades these communities and reduces the human subjects into sexualized objects.

### Why this harm is dangerous
Various groups are prevented from expressing themselves or their work involving nudity because of various social, religious, and legal restrictions imposed on them such as censorship and modesty norms. Twitter provides a safe space: a space for these groups to freely express themselves [1], and it has historically fostered such communities centered on "sensitive content" when other websites shun these groups away. [2, 3] However, unintentionally denigrading these groups into purely sexual entities goes against Twitter's commitment to Equality Civil Liberties for all people. [4]

## Methodology (* are addressed in Limitations)
We identify 4 groups of Twitter users who may be adversely affected: LGBTQ+ Artists, Indigenous Culture Peoples / advocates, White Naturists, and Black Naturists. Originally we only had one group for naturists, but we decided to split it after seeing many naturist pages on Twitter mostly contain images of white naturists only. 

For each of these groups, we identify a user that posts images on these groups and with a sizable following as a proxy for reputation ( > 500). For each user, we collect 15 public images* from their Twitter page via an open-sourced image scraper ([Scweet](https://github.com/Altimis/Scweet)).

We then run Cropper on each image to identify the salient point. We then return the original image with a 200 x 200 pixel rectangle whose center is the salient point superimposed on that image. Finally, we use a detector to classify whether the image area within the rectangle is almost exclusively an intimate part. For our purposes, we use the common definition of intimate parts, which are: buttocks, anus, genitalia, and breasts [5]. We use a positive result, i.e. that the rectangluar region is focused on intimate part/s, as a proxy for sexual objectification and denigration*.

Initially our detector is an open-sourced trained Neural Network called [NudeNet](https://github.com/notAI-tech/NudeNet)*. However, since the accuracy metrics are not publicly reported in the repository and there was a high error rate for our data, we decided to use a human to detect for each image. Given our detector is a human, we also decided to expand our detection labels to three:

1. *is_objectified* - detects for intimate part/s making a majority of the cropped region
2. *is_text* - detects if majority of the cropped region is text / part of text
3. *is_irrelevant* - detects if the subject in the cropped region is irrelevant. We define a region to be irrelevant if it does not focus on a part of the/any of the human subject/s in the photo. 

Note that these labels are mutually exclusive (e.g. if a region has an intimate part, it cannot be irrelevant)

The full table is in **results.csv**. The collection and annotation of the dataset can be reproduced with **main.ipynb**, except for manually collected images. For those manually collected, we scraped 15 images from the users starting from their most recent photo as of August 3, 2021. The analysis code used for the results section can be found in **analysis.r**. We also provide the annotated images in .zipped format. Refer to the table below for details

| Group              | Folder Name                     | Images Owner | Twitter Source                   |
|--------------------|---------------------------------|--------------|----------------------------------|
| LGBTQ+ Artists     | imgs_gay_annotated.zip          | bubentcov    | https://twitter.com/bubentcov    |
| Indigenous Peoples | imgs_tribal_annotated.zip       | tribalnude   | https://twitter.com/tribalnude   |
| White Nudists	     | imgs_nudist_white_annotated.zip | artskyclad   | https://twitter.com/artskyclad   |
| Black Nudists      | imgs_nudist_black_annotated.zip | blknudist75  | https://twitter.com/blknudist75  |
| Samples            | Samples                         | Katrin Dirim | https://twitter.com/kleioscanvas |

## Results

The aggregated results according to each category are shown below:

| Category     | % Objectified | % Text   | % Irrelevant Subject | % Unwanted (Sum of Previous Three Columns) |
|--------------|---------------|----------|----------------------|------------|
| Gay          | 6.6667        | 20       | 0                    | 26.6667   |
| Nudist_Black | 6.25          | 0        | 25                   | 31.25     |
| Nudist_White | 14.2857       | 14.2857  | 0                    | 28.5714   |
| Tribal       | 13.3333       | 6.6667   | 0                    | 20        |

## Discussion

### Objectification

Our results show that a higher proportion of Nudist_White and Tribal images are being objectified by the algorithm compared to the Gay and Nudist_Black images. This shows overall, certain individuals have a higher chance of being cropped in a way that objectifies their images but also that overall, atleast 6% of images in all categories are cropped in this way. This has inherent harm to all users since people posting the images may have other intentions and may want to place focus on something else but the cropping alters their messaging to other users.

### Unwanted Cropping

A higher proportion of Nudist_Black images had unwanted cropping parameters followed by Nudist_White, Gay, and Tribal images. Our hypothesis for this pattern is that the algorithm has more difficulty in identifying dark toned faces compared to other tones present. For example, in the following two images the algorithm highlights the faces present in artworks instead of the individuals themselves.

![two people painting](img_md/2.jpg?raw=true)
![person standing](img_md/1.jpg?raw=true)

These shortcomings may mean the algorithm has a higher likelihood of not choosing darker toned individuals as its focus and so may crop images containing such individuals unfairly or even fail to find the correct subject.

Furthermore, there are other cases, more generally, where the algorithm favors text over actual subjects in photographs. This produces a more general problem for most users since in most cases, the text in images are complementary to the subject (if any) in the image. Therefore, the cropping algorithm will miss the actual subject and will result in harm to users not being able to showcase their images effectively.

## Limitations
This project has several limitations and its findings should thus not be used as definite evidence for the existence of denigration of the affected communities. Rather, this serves to introduce the possibility of harm, and it should serve as a guide for future work that can conclusively identify and address this specific harm.

In particular, we identifed three major limitations:

1. **Our Dataset is extremely small** Our automatic scraper did not work for sensitive content, so we had to resort to manually downloading each image. We also did not have an accurate initmate parts detector model. Both of these prevented us from scaling our dataset to a larger size that can produce more comprehensive conclusions. We were also restricted to single users to represent the entire group, which we acknowledge may adversely restrict the conclusion. For example, for LGBTQ+ Artists, we were only able to pick a user focusing on gay art, which may have precluded more observations of the cropper denigrading. 

However, we belive we took the necessary caution to represent groups as much as our limited analysis power can bring us. For example, as aforementioned, we split the Naturist group into White and Black after noticing that most naturist pages consist overwhelmingly of white people. In general, making a large-scale dataset will be hard given the legal restrictions and the necessary consent of owners involving sensitive data.

2. **Some Images may want to direct attention to Intimate Parts** There are some images whose authors intend the viewers to look at the intimate parts in non- sexual/objectifying ways. Some images may also focus on an intimate part entirely. One prominent example that we have seen are breast paintings/artwork. Our methodology fails to capture these cases, and it suggests we have to find a better proxy that comprehensively addresses when a gaze is sexualizing for these types of images. 

3. **We did not find any reliable Intimate Part Detector Models** While NudeNet was available, it was the only detector we could find. As we have stated, it was inadequate for our purpose. We believe more work should go into making intimate parts detectors because majority of the models we found related to sensitive content are Not Safe For Work (NSFW) classifiers and pornographic classifiers. 

In addition to having more detectors, future work would require training or fintuning to a dataset of similar distribution (ideally images all collected from Twitter) so that the detector would work more accurately.
## Conclusion and Limitations


## References
1. https://www.vox.com/2016/7/5/11949258/safe-spaces-explained
2. https://www.rollingstone.com/culture/culture-features/sex-worker-twitter-deplatform-1118826/
3. https://www.nbcnews.com/feature/nbc-out/lgbtq-out-social-media-nowhere-else-n809796
4. https://about.twitter.com/en/who-we-are/twitter-for-good
5. https://en.wikipedia.org/wiki/Intimate_part
