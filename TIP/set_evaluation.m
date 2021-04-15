clc
clear
%% evaluation on Test Set
addpath('metrics')
video_name = {'[19] Restaurant'};
scale = 4;
degradation = 'BI';
psnr_set = [];
ssim_set = [];
rmse_set = [];
for idx_video = 1:length(video_name)
    psnr_video = [];
    ssim_video = [];
    rmse_video = [];
    name = char(video_name(idx_video))
    path = [degradation '_x' num2str(scale)]
    disp(path)
    video_path = fullfile('results/Set', path, name)
    a=dir([video_path '/*.png'])
    disp(video_path)
    n=numel(a)-1
    disp(n)
    for idx_frame = 3:n-2 				% exclude the first and last 2 frames
        img_hr = imread(['data/test/Set/',video_name{idx_video},'/hr/hr_', num2str(idx_frame,'%d'),'.png']);
        img_sr = imread(['results/Set/',degradation '_x' num2str(scale),'/',video_name{idx_video},'/sr_', num2str(idx_frame,'%02d'),'.png']);
        
        

        h = min(size(img_hr, 1), size(img_sr, 1));
        w = min(size(img_hr, 2), size(img_sr, 2));
        
        border = 6 + scale;
        
        img_hr_ycbcr = rgb2ycbcr(img_hr);
        img_hr_y = img_hr_ycbcr(1+border:h-border, 1+border:w-border, 1);
        img_sr_ycbcr = rgb2ycbcr(img_sr);
        img_sr_y = img_sr_ycbcr(1+border:h-border, 1+border:w-border, 1);
        
        rmse_video(idx_frame-2) = sqrt(mean((img_hr_y(:)-img_sr_y(:)).^2));
        psnr_video(idx_frame-2) = cal_psnr(img_sr_y, img_hr_y);
        ssim_video(idx_frame-2) = cal_ssim(img_sr_y, img_hr_y);
    end
    psnr_set(idx_video) = mean(psnr_video);
    ssim_set(idx_video) = mean(ssim_video);
    rmse_set(idx_video) = mean(rmse_video);
    disp([video_name{idx_video},'---Mean PSNR: ', num2str(mean(psnr_video),'%0.4f'),', Mean SSIM: ', num2str(mean(ssim_video),'%0.4f'),', Mean RMSE: ', num2str(mean(rmse_video),'%0.4f')])
end
disp(['---------------------------------------------'])
disp(['Set ',degradation,'_x', num2str(scale) ,' SR---Mean PSNR: ', num2str(mean(psnr_set),'%0.4f'),', Mean SSIM: ', num2str(mean(ssim_set),'%0.4f'),', Mean RMSE: ', num2str(mean(rmse_set),'%0.4f')])