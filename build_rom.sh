# sync rom
repo init --depth=1 -u git://github.com/DerpFest-11/manifest.git -b 11 -g default,-device,-mips,-darwin,-notdefault
git clone https://github.com/SuperCosmicBeing/frostmanifest.git --depth=1 -b derp .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

#Setup
curl https://gist.githubusercontent.com/SuperCosmicBeing/c6db35d8abfa480e183a66b71ffca563/raw/3f5f1fc6d02ae767479bda37c04ea417a229f7eb/gms_full.mk >> gms_full.mk
mv gms_full.mk vendor/gms/
rm -rf device/generic/opengl-transport

# build rom
source build/envsetup.sh
lunch derp_sakura-user
mka derp

# upload rom
device=$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d _ -f 2 | cut -d - -f 1)
rclone copy out/target/product/sakura/DerpFest*.zip cirrus:$device -P
