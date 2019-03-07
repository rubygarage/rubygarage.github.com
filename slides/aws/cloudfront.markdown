---
layout: slide
title: CloudFront
---
![](/assets/images/aws/cloudfront/logo.jpg)

## [https://aws.amazon.com/cloudfront/](https://aws.amazon.com/cloudfront/) - Get started

---

## What is CloudFront

### Amazon `CloudFront` is a content delivery network
### offered by `Amazon Web Services`.

---

# How does it work

--

We’ve stored our content in an S3 bucket located in a region in Europe, and we have users located around the world who access that content.

![](/assets/images/aws/cloudfront/hw-before.jpg)

`Depending on the user’s location`, this can take a long time.

--

![](/assets/images/aws/cloudfront/hw-after.jpg)

CloudFront serves cached content quickly and directly to the requesting user nearby, as shown with the green arrows. If the content is not yet cached with an edge server, CloudFront retrieves it from the S3 bucket origin. And because the `content traverses the AWS private network` instead of the public internet and CloudFront `optimizes the TCP handshake`, the `request` and `content` return is still `much faster` than access across the public internet.

--

## Tracking Performance

![](/assets/images/aws/cloudfront/perfomance-chart.jpg)

Sometimes the file is returned 100 times faster!

--

# Use Case

![](/assets/images/aws/cloudfront/use-case.png)

1. Amazon CloudFront provides a caching layer to reduce the cost of image processing.
2. Amazon API Gateway provides API endpoint powered by AWS Lambda functions to dynamically make image modifications.
3. AWS Lambda retrieves the image from the existing Amazon Simple Storage Service (Amazon S3) bucket and uses Thumbor to return a modified version of the image to the API Gateway.
4. The API Gateway returns the new image to CloudFront for delivery to end-users.

---

## Accessing CloudFront
- **AWS Management Console**

- **AWS SDKs** – SDKs simplify authentication, integrate easily with your development environment, and provide access to CloudFront [commands.](https://aws.amazon.com/tools/)
  - Developer [Guide](https://aws.amazon.com/sdk-for-ruby/)
  - gem [aws-sdk-rails](https://github.com/aws/aws-sdk-rails)

- **CloudFront API** – If you're using a programming language that an SDK isn't available for, [see how to make API requests.](https://docs.aws.amazon.com/cloudfront/latest/APIReference/Welcome.html)

- **AWS Command Line Interface**

- **AWS Tools for Windows PowerShell**

---

# How Configure CloudFront to Deliver Your Content

--

## - 1 -
### You specify origin servers, like an `Amazon S3 bucket` or your `own HTTP server`, from which CloudFront gets your files which will then be distributed from CloudFront `edge locations` all over the world.

### An origin server stores the original, definitive version of your objects.

--

## - 2 -
### You upload your files to your origin servers. Files can be anything that can be served over HTTP.

### If you're using an `Amazon S3 bucket as an origin server`, you can make the objects in your bucket publicly readable.
### You also have the option of keeping objects private and controlling who accesses them. [Serving Private Content with Signed URLs and Signed Cookies.](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/PrivateContent.html)
![](/assets/images/aws/cloudfront/restrict-access.png)

--

## - 3 -
### You create a `CloudFront distribution`, which tells CloudFront which origin servers to get your files from, when users request the files through your `web site` or `application`.

![](/assets/images/aws/cloudfront/step-3-create-distribution.png)

--

## - 4 -
### CloudFront assigns a `domain name` to your new `distribution` that you can see in the CloudFront console, or that is returned in the response from an API request.

![](/assets/images/aws/cloudfront/step-4-assign-domain.png)

--

## - 5 -
### CloudFront `sends your distribution's configuration` (but not your content) to all of its edge locations—collections of servers in geographically dispersed data centers where CloudFront caches copies of your objects.

![](/assets/images/aws/cloudfront/cf-map.png)

--

![](/assets/images/aws/cloudfront/how-to-configure-cf.png)

---

# Making CloudFront works with Rails

--

## Assets pipeline

In `config/environments/production.rb:`

```ruby
config.action_controller.asset_host = ENV['CLOUDFRONT_DISTRIBUTION_DOMAIN']

# ENV['CLOUDFRONT_DISTRIBUTION_DOMAIN'] => dj19ua31ezj772q.cloudfront.net
```
This has the effect of making all the links you send use the configured asset host instead of that of your own website.

--

Example:
```html
<link href="/assets/application-75ghc0f37d8bfc5fb4283f312698fff9.css rel="stylesheet">
```
The href will now have the configured asset host prepended:
```html
<link href="https://dj19ua31ezj772q.cloudfront.net/assets/application-
75ghc0f37d8bfc5fb4283f312698fff9.css rel="stylesheet">
```

--

## CORS Issue

### If you are loading all the assets on your site via a CDN then the browser may give warnings or errors about using resources from different origins.

--

### Fixing CORS issue with Cloudfront configuration changes. In order to `enabling CORS` we need to configure Cloudfront to `allow forwarding of required headers`. By clicking on Cloudfront Distribution’s `“Distribution Settings”`. Then from the `“Behavior”` tab click on `“Edit”`. Here we need to whitelist the headers that need to be forwarded as shown in the image below.
![](/assets/images/aws/cloudfront/whitelist-headers.png)

--
## Or
### If you have configured `Nginx` proxies which will serve static assets, add config CORS custom headers correctly.
link: [CORS on Nginx](https://enable-cors.org/server_nginx.html)

--

In `config/environments/production.rb:` for Rails 4
```ruby
config.paperclip_images_default_options = {
    styles: {
      thumb: '100x100>',
      small: '300x300>',
      medium: '600x600',
      large: '1200x900'
    },
    default_url: '/images/:style/missing.png',
    path: ':class/:attachment/:id_partition/:style/:basename.:extension',

    # just replace url option with fog_host:
    # url: ':s3_domain_url'

    fog_host: ENV['CLOUDFRONT_DISTRIBUTION_DOMAIN']
  }
```

--

## Well done!

---

## `Pros` of using `CloudFront`
- **Speeds up distribution** of your static and dynamic web content, such as .html, .css, .js, and image files, to your users.
- **Reduce origin traffic**
- **Extensive documentation.**
- It’s **“developer-friendly.”** They offer SDKs for many programming languages (e.g., Ruby, Python, Javascript).
- **Stability.** Amazon CloudFront is not going to close anytime soon.
- **Free Tier**
  - 50 GB OF DATA TRANSFER OUT (12 months free)
  - 2,000,000 HTTP OR HTTPS REQUESTS (Each month for one year)

--

![](/assets/images/aws/cloudfront/pricing-without-cf.jpg)
![](/assets/images/aws/cloudfront/pricing-with-cf.jpg)

---

## `Cons` of using `CloudFront`
## On-demand Pricing
![](/assets/images/aws/cloudfront/pricing.png)

### [current prices](https://aws.amazon.com/cloudfront/pricing/)

---

# The End
