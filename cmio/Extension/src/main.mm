/* akvirtualcamera, virtual camera for Mac and Windows.
 * Copyright (C) 2026  Gonzalo Exequiel Pedone
 *
 * akvirtualcamera is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * akvirtualcamera is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with akvirtualcamera. If not, see <http://www.gnu.org/licenses/>.
 *
 * Web-Site: http://webcamoid.github.io/
 */

#ifndef FAKE_APPLE
#import <Foundation/Foundation.h>
#import <CoreMediaIO/CMIOExtensionProvider.h>

#import "extensionprovidersource.h"
#endif

#include "PlatformUtils/src/utils.h"
#include "VCamUtils/src/logger.h"

int main(int argc, char *argv[])
{
    AkVCam::logSetup();

#ifndef FAKE_APPLE
    @autoreleasepool {
        /* Provider + devices are created inside ExtensionProviderSource init
         * (same order as Apple's sample / VCamCX). */
        ExtensionProviderSource *providerSource =
            [[ExtensionProviderSource alloc] init];

        [CMIOExtensionProvider startServiceWithProvider: providerSource.provider];

        [[NSRunLoop mainRunLoop] run];
    }
#endif

    return 0;
}
