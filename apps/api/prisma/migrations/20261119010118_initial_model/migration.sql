-- CreateTable
CREATE TABLE `User` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `email` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `passwordHash` VARCHAR(191) NOT NULL,

    UNIQUE INDEX `User_email_key`(`email`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Settings` (
    `id` INTEGER NOT NULL DEFAULT 1,
    `kiloMargin` DECIMAL(5, 2) NOT NULL DEFAULT 30,
    `halfMargin` DECIMAL(5, 2) NOT NULL DEFAULT 40,
    `quarterMargin` DECIMAL(5, 2) NOT NULL DEFAULT 45,
    `unitMargin` DECIMAL(5, 2) NOT NULL DEFAULT 30,
    `roundTo` INTEGER NOT NULL DEFAULT 10,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Category` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `sortOrder` INTEGER NOT NULL DEFAULT 0,

    UNIQUE INDEX `Category_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Product` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `categoryId` INTEGER NOT NULL,
    `type` ENUM('SIMPLE', 'MIX') NOT NULL DEFAULT 'SIMPLE',
    `measure` ENUM('WEIGHT', 'UNIT') NOT NULL DEFAULT 'WEIGHT',
    `cost` DECIMAL(12, 2) NULL,
    `usesBag` BOOLEAN NOT NULL DEFAULT true,
    `kiloMargin` DECIMAL(5, 2) NULL,
    `halfMargin` DECIMAL(5, 2) NULL,
    `quarterMargin` DECIMAL(5, 2) NULL,
    `unitMargin` DECIMAL(5, 2) NULL,
    `minStock` DECIMAL(12, 2) NOT NULL DEFAULT 0,
    `isCustom` BOOLEAN NOT NULL DEFAULT false,
    `active` BOOLEAN NOT NULL DEFAULT true,

    INDEX `Product_categoryId_idx`(`categoryId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `MixIngredient` (
    `mixId` INTEGER NOT NULL,
    `ingredientId` INTEGER NOT NULL,

    PRIMARY KEY (`mixId`, `ingredientId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Purchase` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `date` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `supplier` VARCHAR(191) NULL,
    `status` ENUM('DRAFT', 'CONFIRMED') NOT NULL DEFAULT 'DRAFT',
    `shipping` DECIMAL(12, 2) NOT NULL DEFAULT 0,
    `extras` DECIMAL(12, 2) NOT NULL DEFAULT 0,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `PurchaseItem` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `purchaseId` INTEGER NOT NULL,
    `productId` INTEGER NOT NULL,
    `quantity` DECIMAL(12, 2) NOT NULL,
    `baseCost` DECIMAL(12, 2) NOT NULL,
    `effectiveCost` DECIMAL(12, 2) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Supply` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `unitCost` DECIMAL(12, 4) NOT NULL DEFAULT 0,
    `addsToPrice` BOOLEAN NOT NULL DEFAULT true,

    UNIQUE INDEX `Supply_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `ExtraPurchase` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `date` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `description` VARCHAR(191) NOT NULL,
    `total` DECIMAL(12, 2) NOT NULL,
    `quantity` INTEGER NULL,
    `unitCost` DECIMAL(12, 4) NULL,
    `supplyId` INTEGER NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Customer` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `phone` VARCHAR(191) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `CustomerOrder` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `customerId` INTEGER NOT NULL,
    `date` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `status` ENUM('OPEN', 'FINALIZED', 'CANCELED') NOT NULL DEFAULT 'OPEN',
    `deliveredAt` DATETIME(3) NULL,
    `total` DECIMAL(12, 2) NOT NULL DEFAULT 0,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `CustomerOrderItem` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `orderId` INTEGER NOT NULL,
    `productId` INTEGER NOT NULL,
    `presentation` ENUM('KILO', 'HALF', 'QUARTER', 'UNIT') NOT NULL,
    `quantity` INTEGER NOT NULL,
    `unitPrice` DECIMAL(12, 2) NOT NULL,
    `unitCost` DECIMAL(12, 2) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Payment` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `orderId` INTEGER NOT NULL,
    `amount` DECIMAL(12, 2) NOT NULL,
    `date` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `note` VARCHAR(191) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `StockMovement` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `productId` INTEGER NOT NULL,
    `type` ENUM('PURCHASE', 'SALE', 'RETURN', 'ADJUSTMENT', 'WASTE') NOT NULL,
    `quantity` DECIMAL(12, 2) NOT NULL,
    `date` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `purchaseItemId` INTEGER NULL,
    `orderItemId` INTEGER NULL,
    `note` VARCHAR(191) NULL,

    INDEX `StockMovement_productId_idx`(`productId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Product` ADD CONSTRAINT `Product_categoryId_fkey` FOREIGN KEY (`categoryId`) REFERENCES `Category`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MixIngredient` ADD CONSTRAINT `MixIngredient_mixId_fkey` FOREIGN KEY (`mixId`) REFERENCES `Product`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MixIngredient` ADD CONSTRAINT `MixIngredient_ingredientId_fkey` FOREIGN KEY (`ingredientId`) REFERENCES `Product`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `PurchaseItem` ADD CONSTRAINT `PurchaseItem_purchaseId_fkey` FOREIGN KEY (`purchaseId`) REFERENCES `Purchase`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `PurchaseItem` ADD CONSTRAINT `PurchaseItem_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `ExtraPurchase` ADD CONSTRAINT `ExtraPurchase_supplyId_fkey` FOREIGN KEY (`supplyId`) REFERENCES `Supply`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `CustomerOrder` ADD CONSTRAINT `CustomerOrder_customerId_fkey` FOREIGN KEY (`customerId`) REFERENCES `Customer`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `CustomerOrderItem` ADD CONSTRAINT `CustomerOrderItem_orderId_fkey` FOREIGN KEY (`orderId`) REFERENCES `CustomerOrder`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `CustomerOrderItem` ADD CONSTRAINT `CustomerOrderItem_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Payment` ADD CONSTRAINT `Payment_orderId_fkey` FOREIGN KEY (`orderId`) REFERENCES `CustomerOrder`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `StockMovement` ADD CONSTRAINT `StockMovement_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `StockMovement` ADD CONSTRAINT `StockMovement_purchaseItemId_fkey` FOREIGN KEY (`purchaseItemId`) REFERENCES `PurchaseItem`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `StockMovement` ADD CONSTRAINT `StockMovement_orderItemId_fkey` FOREIGN KEY (`orderItemId`) REFERENCES `CustomerOrderItem`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
